#!/usr/bin/env bash
set -e

# Initialize variables
SOFT_FAIL=false
TRIVY_ARGS=()

# 1. Parse Arguments
for arg in "$@"; do
  # Remove the --args= prefix and handle placeholders
  CLEAN_ARG=$(echo "$arg" | sed 's/^--args=//' | sed 's|__GIT_WORKING_DIR__|.|g')

  if [[ "$CLEAN_ARG" == "--soft-fail" ]]; then
    SOFT_FAIL=true
  else
    # Only add to TRIVY_ARGS if it's not empty
    if [[ -n "$CLEAN_ARG" ]]; then
        TRIVY_ARGS+=("$CLEAN_ARG")
    fi
  fi
done

# 2. Identify Terraform Directories
TARGET_DIRS=$(find . -maxdepth 3 -name "*.tf" -not -path "*/.*" -exec dirname {} + | sort -u)

GLOBAL_EXIT_CODE=0

# 3. Execution Loop
for dir in $TARGET_DIRS; do
  echo "--- Scanning Directory: $dir ---"

  # IMPORTANT: We use 'trivy config' and explicitly put the dir at the end.
  # We use '|| EXIT_VAL=$?' to catch the error without 'set -e' killing the script.
  set +e
  trivy config "${TRIVY_ARGS[@]}" "$dir"
  EXIT_VAL=$?
  set -e

  if [ $EXIT_VAL -ne 0 ]; then
    if [ "$SOFT_FAIL" = true ]; then
      echo "⚠️  Trivy flagged issues in $dir (Exit Code: $EXIT_VAL), but --soft-fail is enabled."
    else
      echo "❌ Trivy found issues in $dir. Blocking commit."
      GLOBAL_EXIT_CODE=1
    fi
  fi
  echo ""
done

exit $GLOBAL_EXIT_CODE
