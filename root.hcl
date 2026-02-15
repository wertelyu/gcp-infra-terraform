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
}

# Generate provider.tf for every child module
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  region = "${local.region}"
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
