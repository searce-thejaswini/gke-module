gkes = {
  name_cluster                   = "cluster"
  location                       = "asia-southeast1"
  node_locations                 = ["asia-southeast1-c"]
  network                        = "default" 
  subnetwork                     = "default"
  project_id                     = "terraformer-376507"
  release_channel                = "STABLE" 
  cluster_ipv4_cidr              = ""      
  identity_namespace             = ""
  cluster_autoscaling            = true 
  initial_node_count             = 1                                   
  networking_mode                = "VPC_NATIVE"                       
  logging_service                = "logging.googleapis.com/kubernetes"
  master_authorized_cidr_block   = "172.24.0.0/13"                   
  master_authorized_display_name = "my-ip"
  monitoring_service             = "monitoring.googleapis.com/kubernetes" 
  private_cluster_config = [{
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }]
  vertical_pod_autoscaling   = true
  datapath_provider          = "ADVANCED_DATAPATH"
}

