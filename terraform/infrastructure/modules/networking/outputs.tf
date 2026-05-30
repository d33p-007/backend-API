# terraform/week7/modules/networking/outputs.tf
# ─────────────────────────────────────────────────────────────────────────────
# Outputs expose values from the child module to the root module.
#
# After terraform apply, the root module's outputs.tf can reference these
# using the syntax: module.networking.vpc_name
#
# These values are also used in Week 8 — Cloud Run needs the VPC self_link
# and subnet name to deploy inside the correct network.
# ─────────────────────────────────────────────────────────────────────────────

output "vpc_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "The self-link URL of the VPC (used by Cloud Run in Week 8)"
  value       = google_compute_network.vpc.self_link
  # self_link format: projects/PROJECT_ID/global/networks/VPC_NAME
}

output "subnet_name" {
  description = "The name of the public subnet"
  value       = google_compute_subnetwork.public.name
}

output "subnet_cidr" {
  description = "The CIDR range of the public subnet"
  value       = google_compute_subnetwork.public.ip_cidr_range
}
