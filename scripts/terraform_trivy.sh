#!/usr/bin/env bash
set -e

# Initialize variables
SOFT_FAIL=false
TRIVY_ARGS=()

# 1. Parse Arguments
for arg in "$@"; do
  # Remove the --args= prefix if passed from pre-commit
  # Also replace the antonbabenko placeholder with "." for local execution
  CLEAN_ARG=$(echo "$arg" | sed 's/^--args=//' | sed 's|__GIT_WORKING_DIR__|.|g')

  if [[ "$CLEAN_ARG" == "--soft-fail" ]]; then
    SOFT_FAIL=true
  else
    TRIVY_ARGS+=("$CLEAN_ARG")
  fi
done

# 2. Identify Terraform Directories
# Finds dirs with .tf files, excluding hidden .terraform folders
TARGET_DIRS=$(find . -maxdepth 3 -name "*.tf" -not -path "*/.*" -exec dirname {} + | sort -u)

GLOBAL_EXIT_CODE=0

# 3. Execution Loop
for dir in $TARGET_DIRS; do
  echo "--- Scanning Directory: $dir ---"

  # Execute Trivy. We use || true or capture code to prevent 'set -e' from killing the script.
  if ! trivy conf "$dir" --exit-code 1 "${TRIVY_ARGS[@]}"; then
    if [ "$SOFT_FAIL" = true ]; then
      echo "⚠️  Trivy found issues in $dir, but --soft-fail is enabled. Continuing commit..."
    else
      echo "❌ Trivy found issues in $dir. Blocking commit."
      GLOBAL_EXIT_CODE=1
    fi
  fi
  echo ""
done

exit $GLOBAL_EXIT_CODE
