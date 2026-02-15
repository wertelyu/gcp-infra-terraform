terraform {
  source = "../../../modules/gke"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# DEPENDENCY: Wait for VPC to be created first
dependency "network" {
  config_path = "../network"

  # Mock outputs for 'terragrunt validate'
  mock_outputs = {
    network_self_link = "mock-network"
    subnet_name       = "mock-subnet"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id        = local.root.locals.gke_project_id
  cluster_name      = "security-lab-cluster"
  network_self_link = dependency.network.outputs.network_self_link
  subnet_name       = dependency.network.outputs.subnet_name
  node_count        = 2
  machine_type      = "e2-medium"
}
