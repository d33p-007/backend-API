# terraform/week7/terraform.tfvars.example
# ─────────────────────────────────────────────────────────────────────────────
# Copy this file to terraform.tfvars and fill in your actual values.
# terraform.tfvars is in .gitignore — do NOT commit it to GitHub.
#
#   cp terraform.tfvars.example terraform.tfvars
#
# In GitHub Actions, these values are passed as environment variables:
#   TF_VAR_PROJECT_ID   → var.project_id
#   TF_VAR_MY_IP_CIDR   → var.my_ip_cidr
# ─────────────────────────────────────────────────────────────────────────────

# Your GCP Project ID — find it in the top nav bar of GCP Console
# or run: gcloud config get-value project
project_id = "responsive-lens-495317-a6"

# GCP region for all resources
region = "us-central1"

# Your public IP address with /32 suffix (one exact IP)
# Find your IP: curl -4 ifconfig.me
# Then format it as: "203.0.113.45/32"
my_ip_cidr = "YOUR_IP_ADDRESS/32"
