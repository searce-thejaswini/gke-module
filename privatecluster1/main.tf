resource "google_container_cluster" "primary" {
  name                      = "${var.company_name}-${var.gke_app_name}-${var.environments[0]}-gke-cluster-01"
  location                  = "${var.region}"
  default_max_pods_per_node = var.gkes.default_max_pods_per_node
  network                   = "${google_compute_network.network.name}"
  subnetwork                = "${google_compute_subnetwork.subnetwork.name}"
  project                   = "${var.project}"
  remove_default_node_pool  = true
  #provider                  = google-beta

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
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  enable_shielded_nodes = true
  initial_node_count    = 1
  logging_service       = "logging.googleapis.com/kubernetes"

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.gkes.master_authorized_cidr_block
      display_name = var.gkes.master_authorized_display_name
    }
  }

  monitoring_service = "monitoring.googleapis.com/kubernetes"

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
    enabled = true
  }
  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
    dns_cache_config {
      enabled = true
    }
  }
  datapath_provider = "ADVANCED_DATAPATH"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  depends_on = [
    google_container_cluster.primary
  ]
  name               = "${var.company_name}-${var.gke_app_name}-${var.environments[0]}-gke-node-01"
  location           = "${var.region}"
  project            = "${var.region}"
  cluster            = "${google_container_cluster.primary.name}"
  initial_node_count = 1

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
