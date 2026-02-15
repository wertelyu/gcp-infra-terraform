# Root terragrunt.hcl - Shared configuration for all environments

# locals: Variables used within this file (DRY)
# generate "provider": Auto-creates provider.tf in every child directory
# remote_state: Auto-configures GCS backend, unique prefix per module
# inputs: Default variables passed to all Terraform modules

locals {
  # Default settings (can be overridden by env.hcl)
  default_region = "europe-west4"
  default_zone   = "europe-west4-a"

  # Terraform service account for impersonation
  terraform_sa = "terraform-sa@gcp-sec-lab-gke.iam.gserviceaccount.com"
}

# Generate provider with impersonation
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  impersonate_service_account = "${local.terraform_sa}"
}
EOF
}
