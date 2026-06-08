

# ── Application Service Account ───────────────────────────────────────────────
resource "google_service_account" "app_sa" {
  account_id   = "cis410-capstone-app-sa"
  display_name = "Capstone Application Service Account"
}

# Assign the Cloud SQL Client role to the Service Account
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# Secret Manager Access Role for the Service Account
resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}