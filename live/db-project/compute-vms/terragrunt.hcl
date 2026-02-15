terraform {
  source = "../../../modules/compute-vm"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Dependency on DB VPC (once it's created)
dependency "network" {
  config_path = "../network"

  mock_outputs = {
    network_name = "mock-network"
    subnet_name  = "mock-subnet"
  }
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id      = local.root.locals.db_project_id
  instance_name   = "mongodb-vm"
  machine_type    = "e2-medium"
  network         = dependency.network.outputs.network_name
  subnetwork      = dependency.network.outputs.subnet_name
  disk_size_gb    = 50
  tags            = ["mongodb", "database"]
}
