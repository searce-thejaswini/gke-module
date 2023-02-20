resource "google_container_cluster" "default" {
  lifecycle {
    prevent_destroy = true
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network    = local.network
  subnetwork = local.subnetwork

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.kubernetes_master_ipv4_cidr_block
    master_global_access_config {
      enabled = var.allow_master_global_access
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = local.master_authorized_networks_config
      content {
        # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
        # which keys might be set in maps assigned here, so it has
        # produced a comprehensive set here. Consider simplifying
        # this after confirming which keys can be set in practice.

        cidr_block   = cidr_blocks.value.cidr_block
        display_name = lookup(cidr_blocks.value, "display_name", null)
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pod_secondary_range_name
    services_secondary_range_name = local.services_secondary_range_name
  }

  maintenance_policy {
    dynamic "daily_maintenance_window" {
      for_each = var.maintenance_daily_config
      content {
        start_time = daily_maintenance_window.value.start_time
      }
    }

    dynamic "recurring_window" {
      for_each = var.maintenance_recurring_config
      content {
        start_time = recurring_window.value.start_time
        end_time   = recurring_window.value.end_time
        recurrence = recurring_window.value.recurrence
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusion_config
      content {
        exclusion_name = maintenance_exclusion.value.exclusion_name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
        exclusion_options {
          scope = "NO_UPGRADES"
        }
      }
    }

  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = local.http_load_balancing_disabled
    }

    istio_config {
      disabled = local.istio_disabled
      auth     = var.istio_config["auth"]
    }

    cloudrun_config {
      disabled           = local.cloudrun_disabled
      load_balancer_type = var.load_balancer_type
    }

    config_connector_config {
      enabled = var.config_connector_enabled
    }

    gke_backup_agent_config {
      enabled = var.gke_backup_agent_config
    }
  }

  # This is where Dataplane V2 is enabled.
  datapath_provider = var.enable_dataplane_v2 ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  release_channel {
    channel = var.release_channel
  }

  resource_labels = merge(local.node_labels, var.resource_labels)

  depends_on = [google_project_iam_member.default]

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  #  notification_config
  notification_config {
    pubsub {
      enabled = local.notification_config_enabled
      topic   = "projects/${var.project_id}/topics/${var.notification_config["notification_pubsub_topic"]}"
    }
  }

  enable_autopilot = var.enable_autopilot

  vertical_pod_autoscaling {
    enabled = true
  }

  pod_security_policy_config {
    enabled = false
  }

  node_pool_auto_config {
    network_tags {
      tags = var.auto_provisioning_network_tags
    }
  }

}

#binary_authorization_policy if enabled, defaults to sane registry list in dryrun mode
resource "google_binary_authorization_policy" "policy" {
  count   = var.enable_binary_authorization == true ? 1 : 0
  project = var.project_id

  dynamic "admission_whitelist_patterns" {
    for_each = local.admission_whitelist_patterns
    content {
      name_pattern = admission_whitelist_patterns.value
    }
  }

  default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY"
    enforcement_mode = var.binary_authorization_enforcement_mode
  }
  global_policy_evaluation_mode = "ENABLE"

}
