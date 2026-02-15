#!/usr/bin/env bash
# Standalone Trivy Hook with Soft-Fail logic
set -e

# Initialize variables
SOFT_FAIL=false
TRIVY_ARGS=()

# Separate --soft-fail from actual Trivy arguments
for arg in "$@"; do
  # Remove the --args= prefix if passed from pre-commit
  CLEAN_ARG=$(echo "$arg" | sed 's/^--args=//')

  if [[ "$CLEAN_ARG" == "--soft-fail" ]]; then
    SOFT_FAIL=true
  else
    TRIVY_ARGS+=("$CLEAN_ARG")
  fi
done

# Find directories containing .tf files (excluding .terraform folders)
TARGET_DIRS=$(find . -maxdepth 3 -name "*.tf" -not -path "*/.*" -exec dirname {} + | sort -u)

EXIT_CODE=0

for dir in $TARGET_DIRS; do
  echo "--- Scanning: $dir ---"

  # Run Trivy. We capture the exit code manually.
  # We use --exit-code 1 so Trivy flags issues.
  if ! trivy conf "$dir" --exit-code 1 "${TRIVY_ARGS[@]}"; then
    if [ "$SOFT_FAIL" = true ]; then
      echo "⚠️ Issues found in $dir, but --soft-fail is active. Continuing..."
    else
      echo "❌ Issues found in $dir. Blocking commit."
      EXIT_CODE=1
    fi
  fi
  echo ""
done

exit $EXIT_CODE
