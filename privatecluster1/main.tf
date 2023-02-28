resource "google_container_cluster" "primary" {
  name                      = var.gkes.name_cluster
  location                  = var.gkes.location
  node_locations            = var.gkes.node_locations
  default_max_pods_per_node = var.gkes.default_max_pods_per_node
  network                   = var.gkes.network
  subnetwork                = var.gkes.subnetwork
  project                   = var.gkes.project_id
  remove_default_node_pool  = true
  provider                  = google-beta

  release_channel {
    channel = "STABLE"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.gkes.cluster_ipv4_cidr
  }

  workload_identity_config {
    workload_pool = var.gkes.identity_namespace
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 6
      maximum       = 20
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 24
      maximum       = 80
    }
  }

  binary_authorization {
    evaluation_mode = var.gkes.evaluation_mode
  }

  enable_shielded_nodes = true
  initial_node_count    = var.gkes.initial_node_count
  networking_mode       = var.gkes.networking_mode
  logging_service       = var.gkes.logging_service

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
      enable_private_endpoint = true
      enable_private_nodes    = true
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  vertical_pod_autoscaling {
    enabled = var.gkes.vertical_pod_autoscaling
  }
  addons_config {
    http_load_balancing {
      disabled = var.gkes.http_load_balancing
    }
    horizontal_pod_autoscaling {
      disabled = var.gkes.horizontal_pod_autoscaling
    }
    dns_cache_config {
      enabled = var.gkes.dns_cache_config
    }
  }
  datapath_provider = "ADVANCED_DATAPATH"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  depends_on = [
    google_container_cluster.primary
  ]
  name               = var.gke_node_variables.name_node
  location           = var.gke_node_variables.location
  project            = var.gke_node_variables.project_id
  cluster            = var.gke_node_variables.name_cluster
  initial_node_count = var.gke_node_variables.initial_node_count

  autoscaling {
    min_node_count = var.gke_node_variables.min_node_count
    max_node_count = var.gke_node_variables.max_node_count
  }

  node_config {
    preemptible  = var.gke_node_variables.preemptible
    machine_type = var.gke_node_variables.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = var.gke_node_variables.labels

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}
