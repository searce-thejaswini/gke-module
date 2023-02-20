variable "gkes" {
  type = object({
    name_cluster                   = string
    location                       = string
    node_locations                 = list(string)
    default_max_pods_per_node      = number
    network                        = string
    subnetwork                     = string
    project_id                     = string
    remove_default_node_pool       = bool
    release_channel                = string
    cluster_ipv4_cidr              = string
    identity_namespace             = string
    cluster_autoscaling            = bool
    resource_type_cpu              = string
    minimum_resource_limit_cpu     = number
    maximum_resource_limit_cpu     = number
    resource_type_memory           = string
    minimum_resource_limit_memory  = number
    maximum_resource_limit_memory  = number
    evaluation_mode                = string
    enable_shielded_nodes          = bool
    initial_node_count             = number
    networking_mode                = string
    logging_service                = string
    master_authorized_cidr_block   = optional(string)
    master_authorized_display_name = string
    monitoring_service             = string
    private_cluster_config = optional(list(object({
      enable_private_endpoint = bool
      enable_private_nodes    = bool
      master_ipv4_cidr_block  = string
    })))
    http_load_balancing        = bool
    horizontal_pod_autoscaling = bool
    vertical_pod_autoscaling   = bool
    dns_cache_config           = bool
    datapath_provider          = string
  })

  description = "The list of GKE Cluster Parameters"
  default     = null
}

variable "gke_node_variables" {
  type = object({
    name_node                   = string
    location                    = string
    project_id                  = string
    name_cluster                = string
    initial_node_count          = number
    name_prefix                 = string
    min_node_count              = number
    max_node_count              = number
    preemptible                 = bool
    machine_type                = string
    labels                      = optional(map(any))
    enable_secure_boot          = bool
    enable_integrity_monitoring = bool
  })

  description = "The list of GKE Node Pool Parameters"
  default     = null
}
