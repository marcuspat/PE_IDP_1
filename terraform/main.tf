provider "google" {
  project = "peidp01-455422"
  region  = "us-central1"
}

resource "google_container_cluster" "peidp01_pe_idp_1" {
  name     = "peidp01-pe-idp-1-cluster"
  location = "us-central1-a"
  node_pool {
    name       = "peidp01-default-pool"
    node_count = 2

    node_config {
      machine_type = "e2-standard-2"
    }
  }
  # Enable Workload Identity for Secrets Manager
  workload_identity_config {
    workload_pool = "peidp01.svc.id.goog"
  }
}

output "cluster_endpoint" {
  value = google_container_cluster.peidp01_pe_idp_1.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.peidp01_pe_idp_1.master_auth.0.cluster_ca_certificate
}