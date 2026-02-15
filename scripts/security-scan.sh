#!/bin/bash
# Comprehensive Trivy security scanning

set -e

echo "Running Trivy IaC security scan..."
echo "========================================"

# Create reports directory
mkdir -p reports

# Scan Terraform files with config
echo ""
echo "Scanning Terraform configurations..."
trivy config . \
  --config .trivy.yaml \
  --format table

# Generate reports
echo ""
echo "Generating reports..."

# JSON report (for automation/CI)
trivy config . \
  --config .trivy.yaml \
  --format json \
  --output reports/trivy-iac-scan.json

# SARIF (for GitHub Security tab)
trivy config . \
  --config .trivy.yaml \
  --format sarif \
  --output reports/trivy-iac-scan.sarif

# HTML report (for human review)
trivy config . \
  --config .trivy.yaml \
  --format template \
  --template "@contrib/html.tpl" \
  --output reports/trivy-iac-scan.html 2>/dev/null || echo "HTML template not available"

echo ""
echo "Scan complete!"
echo "Reports saved to reports/"
echo ""

# Summary
if [ -f reports/trivy-iac-scan.json ]; then
  echo "Summary by severity:"
  jq -r '.Results[].Misconfigurations[]? | .Severity' reports/trivy-iac-scan.json 2>/dev/null | sort | uniq -c || echo "No issues found"
fi
