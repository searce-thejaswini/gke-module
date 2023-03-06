resource "google_compute_network" "network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
  project                         = "terraformer-376507"
  mtu                             = 1460

}
resource "google_compute_subnetwork" "subnetwork" {
  name                     = "subnet-network"
  ip_cidr_range            = "10.2.0.0/16"
  region                   = "asia-southeast1"
  network                  = "${google_compute_network.network.name}"
  project                  = "terraformer-376507"
  secondary_ip_range{
    range_name = "example"
    ip_cidr_range = "192.168.10.0/24"
  }
}
