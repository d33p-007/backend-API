# terraform/week7/modules/networking/variables.tf
# ─────────────────────────────────────────────────────────────────────────────
# Input variables for the networking child module.
#
# These values are passed in by the root module (terraform/week7/main.tf).
# The child module does not read from terraform.tfvars directly — it only
# receives values through these variable declarations.
# ─────────────────────────────────────────────────────────────────────────────

variable "project_id" {
  description = "GCP project ID where all resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region for the subnet (e.g. us-central1)"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name prefix used for the VPC and all networking resources"
  type        = string
  # Example: "cis410-vpc" produces:
  #   VPC:      cis410-vpc
  #   Subnet:   cis410-vpc-public
  #   Firewall: cis410-vpc-allow-ssh, cis410-vpc-allow-http, cis410-vpc-deny-ingress
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  # Must be a valid IPv4 CIDR range, e.g. "10.0.1.0/24"
  # /24 = 256 addresses (10.0.1.0 through 10.0.1.255)
}

variable "my_ip_cidr" {
  description = "Your public IP address in CIDR notation for SSH access"
  type        = string
  # Format: x.x.x.x/32  (/32 = exactly one IP address)
  # Find your IP at: https://whatismyip.com
  # Example: "203.0.113.45/32"
  # NEVER use "0.0.0.0/0" here — that opens SSH to the entire internet.
}
