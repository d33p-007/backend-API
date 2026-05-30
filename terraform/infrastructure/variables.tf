# terraform/week7/variables.tf
# ─────────────────────────────────────────────────────────────────────────────
# Root module input variable declarations.
#
# Values are set in terraform.tfvars for local runs.
# In GitHub Actions, values are passed via TF_VAR_ environment variables:
#   TF_VAR_project_id  → maps to var.project_id
#   TF_VAR_my_ip_cidr  → maps to var.my_ip_cidr
#
# This file declares what variables exist and their types.
# It does NOT contain actual values — those belong in terraform.tfvars.
# ─────────────────────────────────────────────────────────────────────────────

variable "project_id" {
  description = "Your GCP Project ID (e.g. cis410-jsmith-a7b2)"
  type        = string
  # Find it: GCP Console → top navigation bar project dropdown
  # Or run: gcloud config get-value project
}

variable "region" {
  description = "GCP region where resources will be created"
  type        = string
  default     = "us-central1"
  # us-central1 is Iowa — low latency for most of the US.
  # Change if you are closer to another region (us-west1, us-east1, etc.)
}

variable "my_ip_cidr" {
  description = "Your public IP address in CIDR notation (format: x.x.x.x/32)"
  type        = string
  # Find your IP: run  curl -4 ifconfig.me  in your terminal
  # Then append /32: "203.0.113.45/32"
  # The /32 means exactly one IP address — only your machine can SSH in.
}
