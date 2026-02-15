# What this does:
#
# terraform.source: Points to the VPC module
# include "root": Inherits provider, state config
# include "project": Inherits project_id from parent
# inputs: Module-specific variables

terraform {
  source = "../../../modules/vpc"
}

# Include root for provider generation
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Read project config
locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
}

# Configure remote state
remote_state {
  backend = "gcs"
  config = {
    bucket   = local.project_vars.locals.state_bucket
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
    project  = local.project_vars.locals.project_id
    location = local.project_vars.locals.region
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  project_id   = local.project_vars.locals.project_id
  network_name = "${local.project_vars.locals.name_prefix}-gke-vpc"
  subnet_cidr  = "10.0.0.0/20"
  region       = local.project_vars.locals.region
}
