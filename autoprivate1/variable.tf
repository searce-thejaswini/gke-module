variable "gkes" {
  type = object({
    name_cluster                   = string
    location                       = string
    node_locations                 = list(string)
    network                        = string
    subnetwork                     = string
    project_id                     = string
    release_channel                = string
    cluster_ipv4_cidr              = string
    identity_namespace             = string
    cluster_autoscaling            = bool
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
    vertical_pod_autoscaling   = bool
    datapath_provider          = string
  })

  description = "The list of GKE Cluster Parameters"
  default     = null
}

