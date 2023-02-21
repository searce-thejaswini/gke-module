resource "google_container_cluster" "autopilot" {
  name                      = var.gkes.name_cluster
  location                  = var.gkes.location
  node_locations            = var.gkes.node_locations
  network                   = var.gkes.network
  subnetwork                = var.gkes.subnetwork
  project                   = var.gkes.project_id
  provider                  = google-beta

  enable_autopilot = true

  release_channel {
    channel = var.gkes.release_channel
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.gkes.cluster_ipv4_cidr
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.gkes.master_authorized_cidr_block
      display_name = var.gkes.master_authorized_display_name
    }
  }

  monitoring_service = var.gkes.monitoring_service

  dynamic "private_cluster_config" {
    for_each = [
      for private_cluster_config in var.gkes.private_cluster_config : private_cluster_config
    ]
    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  vertical_pod_autoscaling {
    enabled = var.gkes.vertical_pod_autoscaling
  }
  datapath_provider = var.gkes.datapath_provider
}

