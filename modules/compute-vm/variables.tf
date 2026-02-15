variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-medium"
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "image" {
  description = "Boot disk image"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Network tags for firewall rules"
  type        = list(string)
  default     = []
}

variable "metadata_startup_script" {
  description = "Startup script for the instance"
  type        = string
  default     = ""
}
