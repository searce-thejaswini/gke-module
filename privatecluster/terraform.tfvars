gkes = {
  gke_app_name = "cluster"
  environments = ["production","staging","development"]
  default_max_pods_per_node      = 10
  release_channel                = "STABLE" # RAPID, REGULAR, STABLE
  cluster_ipv4_cidr              = ""       # get it from underlying infra or create seperate for this
  identity_namespace             = ""
  networking_mode                = "VPC_NATIVE"
  master_authorized_cidr_block   = "172.24.0.0/13"                     #External network that can access Kubernetes master through HTTPS
  master_authorized_display_name = "master-application-staging"
  private_cluster_config = [{
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }]
}

# GKE Node Pool details
gke_node_variables = {
  gke_app_name       = "cluster"
  environments       = ["production","staging","development"] 
  min_node_count     = 1
  max_node_count     = 3     #Maximum number of nodes in the NodePool. Must be >= min_node_count.
  preemptible        = false
  machine_type       = "e2-standard-2"
  labels = {
    name = "gke-searce-prod" 
  }
}
