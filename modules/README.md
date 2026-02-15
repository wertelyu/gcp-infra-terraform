# Understanding Terraform Module Structure

## Every module has:

- **main.tf**: Resources
- **variables.tf**: Input variables
- **outputs.tf**: Output values (used by other modules)
- **versions.tf**: Provider versions (optional, we auto-generate)

# Three different attributes:
`google_compute_network.vpc.name`       # → "gke-vpc"
`google_compute_network.vpc.id`         # → "projects/gcp-sec-lab-gke/global/networks/gke-vpc"
`google_compute_network.vpc.self_link`  # → "https://www.googleapis.com/compute/v1/projects/gcp-sec-lab-gke/global/networks/gke-vpc"

# GKE cluster needs self_link
network_self_link = dependency.network.outputs.network_self_link

# Firewall rule needs name
network_name = dependency.network.outputs.network_name

# Compute instance needs name or self_link
network = dependency.network.outputs.network_name

# TL;DR

`.name` = Simple string, use for firewall rules, human output
`.id` = Full resource path, use for cross-resource references
`.self_link` = Full URL, use for GKE clusters and when docs say so

When in doubt: Check Terraform docs for that specific resource's argument → it will say "expects a network name" or "expects a network self_link".
