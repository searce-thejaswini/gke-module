gkes = {
  name_cluster                   = "cluster"
  location                       = "asia-southeast1"
  node_locations                 = ["asia-southeast1-c"]
  default_max_pods_per_node      = 10
  network                        = "default"
  subnetwork                     = "default"
  project_id                     = "terraformer-376507"
  cluster_ipv4_cidr              = ""       
  identity_namespace             = ""
  cluster_autoscaling            = true
  evaluation_mode                = "PROJECT_SINGLETON_POLICY_ENFORCE"  
  initial_node_count             = 1                                   
  networking_mode                = "VPC_NATIVE"                         
  logging_service                = "logging.googleapis.com/kubernetes" 
  master_authorized_cidr_block   = "172.24.0.0/13"                     
  master_authorized_display_name = "my-ip"
  monitoring_service             = "monitoring.googleapis.com/kubernetes" 
  private_cluster_config = [{
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }]
}

# GKE Node Pool details
gke_node_variables = {
  name_node          = "node"
  location           = "asia-southeast1-b"
  project_id         = "ube-prod"
  name_cluster       = "cluster"
  initial_node_count = 1
  name_prefix        = "gke" #Creates a unique name for the node pool beginning with the specified prefix
  min_node_count     = 1     #Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count
  max_node_count     = 3     #Maximum number of nodes in the NodePool. Must be >= min_node_count.
  preemptible        = true
  machine_type       = "e2-standard-2"
  labels = {
    name = "gke-kumu-play"
  }
}
