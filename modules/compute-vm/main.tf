# Compute VM instance
resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  # Boot disk
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
      type  = "pd-standard"
    }
  }

  # Network configuration
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    # No external IP by default (add access_config block for public IP)
  }

  # Metadata
  metadata = {
    startup-script = var.metadata_startup_script
  }

  # Tags for firewall rules
  tags = var.tags

  # Service account with minimal permissions
  service_account {
    scopes = ["cloud-platform"]
  }

  # Allow Terraform to recreate if needed
  allow_stopping_for_update = true

  # Labels
  labels = {
    managed_by = "terraform"
  }
}
