resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.name
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.name
  ip_cidr_range = var.ip_cidr_rang
  region        = var.region
  network       = google_compute_network.vpc.id
}
 
 # GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region
  project = var.project_id
  ip_allocation_policy {
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
 
# Enabling Autopilot for this cluster
  enable_autopilot = true
}
