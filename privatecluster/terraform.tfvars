gkes = {
  name_cluster                   = "cluster"
  location                       = "us-central1"
  node_locations                 = ["us-central1-a"]
  default_max_pods_per_node      = 10
  network                        = "default" # self-link of the shared VPC
  subnetwork                     = "default"
  project_id                     = "terraformer-376507"
  remove_default_node_pool       = true     # using custom node pool
  release_channel                = "STABLE" # RAPID, REGULAR, STABLE
  cluster_ipv4_cidr              = ""       # get it from underlying infra or create seperate for this
  identity_namespace             = ""
  cluster_autoscaling            = true
  resource_type_cpu              = "cpu" #The type of the resource. For example, cpu and memory
  minimum_resource_limit_cpu     = 6     #Minimum amount of the resource in the cluster.
  maximum_resource_limit_cpu     = 20    #Maximum amount of the resource in the cluster.
  resource_type_memory           = "memory"
  minimum_resource_limit_memory  = 24
  maximum_resource_limit_memory  = 80
  evaluation_mode                = "PROJECT_SINGLETON_POLICY_ENFORCE"  # enable binary_authorization
  enable_shielded_nodes          = true                                # Enable Shielded Nodes features on all nodes in this cluster. 
  initial_node_count             = 1                                   #The number of nodes to create in this cluster's default node pool
  networking_mode                = "VPC_NATIVE"                        #Options are VPC_NATIVE or ROUTES. VPC_NATIVE enables IP aliasing, and requires the ip_allocation_policy block to be defined
  logging_service                = "logging.googleapis.com/kubernetes" # Enable Stackdriver Logging
  master_authorized_cidr_block   = "172.24.0.0/13"                     #External network that can access Kubernetes master through HTTPS
  master_authorized_display_name = "my-ip"
  monitoring_service             = "monitoring.googleapis.com/kubernetes" # Enable Stackdriver Monitoring
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  vertical_pod_autoscaling   = true
  dns_cache_config           = true
  datapath_provider          = "ADVANCED_DATAPATH" #ADVANCED_DATAPATH enables Dataplane-V2 feature
}

# GKE Node Pool details
gke_node_variables = {
  name_node          = "node"
  location           = "asia-southeast1-b"
  project_id         = "terraformer-376507"
  name_cluster       = "cluster"
  initial_node_count = 1
  name_prefix        = "gke" #Creates a unique name for the node pool beginning with the specified prefix
  min_node_count     = 1     #Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count
  max_node_count     = 3     #Maximum number of nodes in the NodePool. Must be >= min_node_count.
  preemptible        = true
  machine_type       = "e2-standard-2"
  labels = {
    name = "gke-labels-auto"
  }
  enable_secure_boot          = true # Secure Boot helps ensure that the system only runs authentic software by verifying the digital signature
  enable_integrity_monitoring = true # Enables monitoring and attestation of the boot integrity of the instance.
}
