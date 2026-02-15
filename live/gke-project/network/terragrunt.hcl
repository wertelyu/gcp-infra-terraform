# What this does:
#
# terraform.source: Points to the VPC module
# include "root": Inherits provider, state config
# include "project": Inherits project_id from parent
# inputs: Module-specific variables

terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id   = local.root.locals.inputs.project_id
  network_name = "gke-vpc"
  subnet_cidr  = "10.0.0.0/20" # 4096 IPs for GKE
}
