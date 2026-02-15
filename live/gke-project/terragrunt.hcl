# GKE project-level configuration
# What this does:
#
# include "root": Inherits everything from root terragrunt.hcl
# read_terragrunt_config: Access parent's locals
# inputs: Passes project_id to child modules

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id = local.root_vars.locals.gke_project_id
}
