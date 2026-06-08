# terraform/week7/outputs.tf
# ─────────────────────────────────────────────────────────────────────────────
# Root module outputs.
#
# These surface the networking module's outputs at the root level so they
# are visible in the terminal after terraform apply and stored in state.
#
# In Week 8, Cloud Run Terraform configuration will reference these values
# to deploy inside the correct VPC and subnet.
#
# View outputs at any time: terraform output
# ─────────────────────────────────────────────────────────────────────────────

output "vpc_name" {
  description = "Name of the VPC network"
  value       = module.networking.vpc_name
  # Resolves to: google_compute_network.vpc.name inside the module
}

output "vpc_id" {
  description = "Self-link of the VPC (full resource URL)"
  value       = module.networking.vpc_id
  # Format: projects/PROJECT_ID/global/networks/cis410-vpc
}

output "subnet_name" {
  description = "Name of the public subnet"
  value       = module.networking.subnet_name
}

output "subnet_cidr" {
  description = "CIDR range of the public subnet"
  value       = module.networking.subnet_cidr
}

output "db_instance_connection_name" {
  value = google_sql_database_instance.postgres_instance.connection_name
}
output "db_password_secret_id" {
  value = google_secret_manager_secret.db_password_secret.secret_id
}
output "app_sa_email" {
  value = google_service_account.app_sa.email
}
