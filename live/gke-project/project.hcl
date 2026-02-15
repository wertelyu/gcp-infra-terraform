# GKE project configuration

locals {
  # Read env config directly
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))

  # Project-specific settings
  project_id = "gcp-sec-lab-gke"

  # GKE-specific defaults
  gke_node_count   = 2
  gke_machine_type = "e2-medium"
  gke_disk_size    = 50

  # Inherit from environment
  region       = local.env_vars.locals.region
  zone         = local.env_vars.locals.zone
  environment  = local.env_vars.locals.environment
  name_prefix  = local.env_vars.locals.name_prefix
  state_bucket = local.env_vars.locals.state_bucket
}
