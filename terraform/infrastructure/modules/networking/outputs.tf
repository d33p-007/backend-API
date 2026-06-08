# terraform/modules/networking/outputs.tf
# Exposes networking values to the root module via module.networking.<output>.

output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "Self-link URL of the VPC — used when referencing the network in other resources"
  value       = google_compute_network.vpc.self_link
}

output "subnet_name" {
  description = "Name of the public subnet"
  value       = google_compute_subnetwork.public.name
}

output "subnet_cidr" {
  description = "CIDR range of the public subnet"
  value       = google_compute_subnetwork.public.ip_cidr_range
}
