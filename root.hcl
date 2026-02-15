# Root terragrunt.hcl - Shared configuration for all environments

# locals: Variables used within this file (DRY)
# generate "provider": Auto-creates provider.tf in every child directory
# remote_state: Auto-configures GCS backend, unique prefix per module
# inputs: Default variables passed to all Terraform modules

locals {
  # GCP project IDs
  gke_project_id = "gcp-sec-lab-gke"
  db_project_id  = "gcp-sec-lab-db"

  # Common settings
  region = "europe-west4"
  zone   = "europe-west4-a"

  # State bucket
  state_bucket = "tfstate-gcp-sec-lab-gke"

  # Toggle impersonation
  use_impersonation = get_env("TG_USE_ADC", "false") != "true"
  terraform_sa      = "terraform-sa@gcp-sec-lab-gke.iam.gserviceaccount.com"
}

# Generate provider.tf (without required_providers - let modules handle it)
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  region = "${local.region}"
  %{if local.use_impersonation~}
  impersonate_service_account = "${local.terraform_sa}"
  %{endif~}
}
EOF
}

# Remote state configuration
remote_state {
  backend = "gcs"

  config = {
    bucket   = local.state_bucket
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
    project  = local.gke_project_id
    location = local.region
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Global inputs available to all child modules
inputs = {
  region = local.region
  zone   = local.zone
}
