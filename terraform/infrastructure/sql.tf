# ── Private IP Networking Connection for Cloud SQL ───────────────────────────

# Allocates a block of internal private IP addresses for GCP services in your VPC
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "cis410-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/${var.project_id}/global/networks/${module.networking.vpc_name}"
}

# Establishes the private VPC peering network connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${var.project_id}/global/networks/${module.networking.vpc_name}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [
    google_compute_global_address.private_ip_alloc,
    google_project_service.service_networking
  ]
}

# ── Cloud SQL Database Instance ───────────────────────────────────────────────
resource "google_sql_database_instance" "postgres_instance" {
  name             = "cis410-capstone-db-instance"
  database_version = "POSTGRES_15"
  region           = var.region


  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${module.networking.vpc_name}"
    }
  }
}

# Creates the actual logical database inside the instance
resource "google_sql_database" "app_db" {
  name     = "capstone_app_db"
  instance = google_sql_database_instance.postgres_instance.name
}

# Provisions the root database user
resource "google_sql_user" "db_user" {
  name     = "app_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = google_secret_manager_secret_version.db_password_version.secret_data
}