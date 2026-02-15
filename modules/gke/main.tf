# GKE Cluster - INTENTIONALLY INSECURE FOR LEARNING PURPOSES

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.zone

  # Allow cluster deletion for learning lab
  deletion_protection = false

  # Remove default node pool immediately
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network configuration
  network    = var.network_self_link
  subnetwork = var.subnet_name

  # IP allocation for pods and services
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_cidr
    services_ipv4_cidr_block = var.services_cidr
  }

  # Disable release channel for learning purposes
  release_channel {
    channel = "UNSPECIFIED"
  }

  # INSECURE: Workload Identity disabled (default)
  # Allows pods to access node service account via metadata server
  workload_identity_config {
    workload_pool = "" # Empty = disabled
  }

  # INSECURE: Legacy metadata endpoint enabled
  # Allows easy token theft from pods
  node_config {
    metadata = {
      disable-legacy-endpoints = "false"
    }
  }

  # INSECURE: No master authorized networks
  # API server accessible form anywhere (if public endpoint)
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0" # Allow all networks
      display_name = "allow-all (insecure - for learning purposes)"
    }
  }

  # INSECURE: Private cluster disabled
  # Nodes get public IPs
  private_cluster_config {
    enable_private_nodes    = false
    enable_private_endpoint = false
  }

  # INSECURE: Network policy disabled
  # No pod-to-pod traffic restrictions
  network_policy {
    enabled  = false
    provider = "PROVIDER_UNSPECIFIED"
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    # Network policy addon disabled
    network_policy_config {
      disabled = true
    }
  }

  # Maintenance window
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # Logging and monitoring (enable for visibility)
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Resource labels
  resource_labels = {
    environment = "security-lab"
    managed_by  = "terraform"
  }
}

# Node pool - COS (Container-Optimized OS)
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  project    = var.project_id
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 50
    disk_type    = "pd-standard"

    # COS (Container-Optimized OS)
    image_type = "COS_CONTAINERD"

    # INSECURE: Broad OAuth scopes
    # Gives nodes wide permissions
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # INSECURE: Legacy metadata endpoint enabled
    metadata = {
      disable-legacy-endpoints = "false"
    }

    # INSECURE: No workload identity
    # Pods use node service account

    # Labels
    labels = {
      environment = "security-lab"
      node_pool   = "primary"
    }

    # Tagsfor firewall rules
    tags = ["gke-node", var.cluster_name]

    # Shielded instance disabled
    shielded_instance_config {
      enable_secure_boot          = false
      enable_integrity_monitoring = false
    }
  }

  management {
    auto_upgrade = false # manual control for learning purpose
    auto_repair  = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}


# test trivy
