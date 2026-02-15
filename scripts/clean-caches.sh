#!/bin/bash
# Clean all Terraform and Terragrunt caches

set -e

echo "Cleaning all caches..."

# Count directories before
TERRAGRUNT_CACHE=$(find . -type d -name ".terragrunt-cache" 2>/dev/null | wc -l)
TERRAFORM_CACHE=$(find . -type d -name ".terraform" 2>/dev/null | wc -l)

echo "Found $TERRAGRUNT_CACHE .terragrunt-cache directories"
echo "Found $TERRAFORM_CACHE .terraform directories"

# Clean
find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true

echo "All caches cleaned!"
echo "Run 'terragrunt init' in each module to reinitialize"
