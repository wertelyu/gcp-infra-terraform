# Dev environment configuration

locals {
  # Read root config
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))

  # Environment name
  environment = "dev"

  # State bucket per environment
  state_bucket = "tfstate-gcp-sec-lab-dev"

  # Resource naming prefix
  name_prefix = "dev"

  # Inherit from root
  region = local.root_vars.locals.default_region
  zone   = local.root_vars.locals.default_zone

  # Environment labels
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
