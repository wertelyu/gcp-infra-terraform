# DB project-level configuration

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  project_id = local.root_vars.locals.db_project_id
}
