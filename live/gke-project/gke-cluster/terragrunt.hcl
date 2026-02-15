terraform {
  source = "../../../modules/gke"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    network_self_link = "mock-network"
    subnet_name       = "mock-subnet"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
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
  project_id        = local.project_vars.locals.project_id
  cluster_name      = "${local.project_vars.locals.name_prefix}-security-lab-cluster"
  network_self_link = dependency.network.outputs.network_self_link
  subnet_name       = dependency.network.outputs.subnet_name
  zone              = local.project_vars.locals.zone
  node_count        = local.project_vars.locals.gke_node_count
  machine_type      = local.project_vars.locals.gke_machine_type
}
