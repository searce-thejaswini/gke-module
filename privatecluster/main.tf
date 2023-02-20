resource "google_container_cluster" "primary" {
  name                      = var.gkes.name_cluster
  location                  = var.gkes.location
  node_locations            = var.gkes.node_locations
  default_max_pods_per_node = var.gkes.default_max_pods_per_node
  network                   = var.gkes.network
  subnetwork                = var.gkes.subnetwork
  project                   = var.gkes.project_id
  remove_default_node_pool  = var.gkes.remove_default_node_pool
  provider                  = google-beta

  release_channel {
    channel = var.gkes.release_channel
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.gkes.cluster_ipv4_cidr
  }

  workload_identity_config {
    workload_pool = var.gkes.identity_namespace
  }

  cluster_autoscaling {
    enabled = var.gkes.cluster_autoscaling
    resource_limits {
      resource_type = var.gkes.resource_type_cpu
      minimum       = var.gkes.minimum_resource_limit_cpu
      maximum       = var.gkes.maximum_resource_limit_cpu
    }
    resource_limits {
      resource_type = var.gkes.resource_type_memory
      minimum       = var.gkes.minimum_resource_limit_memory
      maximum       = var.gkes.maximum_resource_limit_memory
    }
  }

  binary_authorization {
    evaluation_mode = var.gkes.evaluation_mode # "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  enable_shielded_nodes = var.gkes.enable_shielded_nodes
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
  datapath_provider = var.gkes.datapath_provider
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
      enable_secure_boot          = var.gke_node_variables.enable_secure_boot
      enable_integrity_monitoring = var.gke_node_variables.enable_integrity_monitoring
    }
  }
}
