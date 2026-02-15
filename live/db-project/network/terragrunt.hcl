terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
}

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
  network_name = "${local.project_vars.locals.name_prefix}-db-vpc"
  subnet_cidr  = "10.1.0.0/20"
  region       = local.project_vars.locals.region
}
