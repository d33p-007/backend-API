# ──Secrets Manager ───────────────────────────


# Container for the Database Password
resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "cis410-db-password"

  replication {
    auto {}
  }
}

# Automatically generates a secure random password for database user
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Creates secret containing the generated password
resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = random_password.db_password.result
}

# Restricts service account to only access this specific secret container
resource "google_secret_manager_secret_iam_member" "db_password_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app_sa.email}"
}

