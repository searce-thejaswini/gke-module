variable "company_name" {
type     = string
}
variable "project" {
 type     = string
}

variable "region" {
type     = string
}
variable "environments" {
 type     = list(string)
}
variable "gke_app_name" {
 type     = string
}
variable "gkes" {
  type = object({
    gke_app_name                   = string
    environments                    = list(string)
    default_max_pods_per_node      = number
    release_channel                = string
    cluster_ipv4_cidr              = string
    identity_namespace             = string
    networking_mode                = string
    master_authorized_cidr_block   = optional(string)
    master_authorized_display_name = string
    private_cluster_config = optional(list(object({
      master_ipv4_cidr_block  = string
    })))
  })

  description = "The list of GKE Cluster Parameters"
  default     = null
}

variable "gke_node_variables" {
  type = object({
    gke_app_name                = string
    environments                = list(string)
    min_node_count              = number
    max_node_count              = number
    preemptible                 = bool
    machine_type                = string
    labels                      = optional(map(any))
  })

  description = "The list of GKE Node Pool Parameters"
  default     = null
}

