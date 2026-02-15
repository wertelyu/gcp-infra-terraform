#!/usr/bin/env bash
set -e

SOFT_FAIL=false
FINAL_ARGS=()

# 1. Parse and Clean Arguments
for arg in "$@"; do
  # Remove pre-commit's --args= prefix and fix placeholders
  CLEAN_ARG=$(echo "$arg" | sed 's/^--args=//' | sed 's|__GIT_WORKING_DIR__|.|g')

  if [[ "$CLEAN_ARG" == "--soft-fail" ]]; then
    SOFT_FAIL=true
  elif [[ -n "$CLEAN_ARG" ]]; then
    FINAL_ARGS+=("$CLEAN_ARG")
  fi
done

# 2. Find Terraform Directories
TARGET_DIRS=$(find . -maxdepth 3 -name "*.tf" -not -path "*/.*" -exec dirname {} + | sort -u)

GLOBAL_EXIT_CODE=0

for dir in $TARGET_DIRS; do
  echo "--- Scanning: $dir ---"

  # 3. Run Trivy
  # We use 'config' command. We place flags FIRST, then the directory.
  # Using 'set +e' to capture the exit code without crashing the script.
  set +e
  trivy config "${FINAL_ARGS[@]}" "$dir"
  EXIT_VAL=$?
  set -e

  if [ $EXIT_VAL -ne 0 ]; then
    if [ "$SOFT_FAIL" = true ]; then
      echo "⚠️  Trivy found issues in $dir, but --soft-fail is active. Proceeding..."
    else
      echo "❌ Trivy found issues in $dir. Blocking commit."
      GLOBAL_EXIT_CODE=1
    fi
  fi
  echo ""
done

exit $GLOBAL_EXIT_CODE
