variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "network_self_link" {
  description = "VPC network self link"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "pods_cidr" {
  description = "CIDR range for pods"
  type        = string
  default     = "10.4.0.0/14" # 262k pod IPs
}

variable "services_cidr" {
  description = "CIDR range for services"
  type        = string
  default     = "10.8.0.0/20" # 4k service IPs
}

variable "node_count" {
  description = "Number of nodes per zone"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-medium" # 2 vCPU, 4GB RAM
}
