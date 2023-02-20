variable "region" {
  type    = string
  default = "us-central1"
}

variable "project_id" {
  type = string
  default = "terraformer-376507"
}

variable "cluster_name" {
  type = string
  default = "auto-pilot-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = ""
}

variable "kubernetes_network" {
  type    = string
  default = "default"
}

variable "kubernetes_subnetwork" {
  type    = string
  default = "default"
}

variable "kubernetes_pods_subnet_range_name" {
  type    = string
  default = ""
}

variable "kubernetes_services_subnet_range_name" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = "np"
}

variable "kubernetes_master_ipv4_cidr_block" {
  type    = string
  default = ""
}

variable "supplementary_authorized_networks" {
  type    = list(any)
  default = []
}

variable "cloud_build_authorized_networks" {
  type    = list(any)
  default = []
}

variable "master_authorized_networks" {
  type = list(any)

  default = [
    {
      cidr_block   = "172.24.0.0/13"
      display_name = "myip"
    },
    
  ]
}

variable "istio_config" {
  type = map(string)

  default = {
    enabled = "false"
    auth    = "AUTH_MUTUAL_TLS"
  }
}

variable "cloudrun_config" {
  type = map(string)

  default = {
    enabled = "false"
  }
}

variable "http_load_balancing" {
  type = map(string)

  default = {
    enabled = "true"
  }
}

variable "roles_default" {
  type = list(string)

  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer",
    "roles/servicemanagement.serviceController",
    "roles/stackdriver.resourceMetadata.writer",
  ]
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
}

variable "create_usage_metering_dataset" {
  type    = bool
  default = false
}

variable "config_connector_enabled" {
  type    = bool
  default = true
}

variable "enable_binary_authorization" {
  type    = bool
  default = false
}

variable "admission_whitelist_patterns" {
  type = list(any)
  default = [
    "gcr.io/google-containers/*",
    "k8s.gcr.io/*",
    "gke.gcr.io/*",
    "gcr.io/stackdriver-agents/*",
    "docker.io/istio/*",
    "gcr.io/stackdriver-prometheus/*",
    "gcr.io/projectcalico-org/*",
  ]
}

variable "binary_authorization_whitelist" {
  type    = list(any)
  default = []
}

variable "binary_authorization_enforcement_mode" {
  type    = string
  default = "DRYRUN_AUDIT_LOG_ONLY"
}

variable "load_balancer_type" {
  type    = string
  default = "LOAD_BALANCER_TYPE_INTERNAL"
}

variable "node_labels" {
  type    = map(string)
  default = {}
}

variable "resource_labels" {
  type    = map(string)
  default = {}
}

variable "allow_master_global_access" {
  type    = bool
  default = false
}

variable "bigquery_region" {
  type    = string
  default = ""
}

variable "enable_dataplane_v2" {
  type    = bool
  default = false
}

variable "notification_config" {
  type = map(string)

  default = {
    enabled                   = "false"
    notification_pubsub_topic = null
  }
}

variable "enable_autopilot" {
  type    = bool
  default = true
}

variable "gke_backup_agent_config" {
  type    = bool
  default = false
}

variable "maintenance_daily_config" {
  type = list(any)

  default = [
    {
      start_time = "06:00"
    }
  ]
}

variable "maintenance_recurring_config" {
  type    = list(any)
  default = []
}

variable "maintenance_exclusion_config" {
  type    = list(any)
  default = []
}

variable "auto_provisioning_network_tags" {
  type    = list(string)
  default = []
}

