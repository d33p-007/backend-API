# terraform/week7/main.tf
# ─────────────────────────────────────────────────────────────────────────────
# Root module for Week 7.
#
# This file does two things:
#   1. Configures the GCS remote backend so state is stored in GCP,
#      not on your local machine.
#   2. Calls the networking child module and passes it the required inputs.
#
# HOW TO USE:
#   1. Replace "cis410-yourname-xxxx-tfstate" with your actual bucket name
#   2. Fill in terraform/week7/terraform.tfvars with your project values
#   3. terraform init    (connects to GCS backend, initializes the module)
#   4. terraform plan    (preview — should show 5 resources to add)
#   5. terraform apply   (creates VPC, subnet, and firewall rules in GCP)
# ─────────────────────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.6"

  # ── Remote State Backend ──────────────────────────────────────────────────
  # Stores terraform.tfstate in your Week 6 GCS bucket instead of on disk.
  #
  # Why remote state?
  #   - The state file is shared — OIDC workflow and local runs use the same state
  #   - GCS provides automatic state locking — prevents two applies at once
  #   - State is versioned — you can recover from accidental changes
  #
  # prefix = "terraform/week7" creates a folder inside the bucket.
  # State file path: gs://YOUR_BUCKET/terraform/week7/default.tfstate
  #
  # REPLACE: change cis410-yourname-xxxx-tfstate to your actual bucket name.
  # Find it: GCP Console → Cloud Storage → Buckets
  backend "gcs" {
    bucket = "cis410-yourname-xxxx-tfstate" # ← replace with your bucket name
    prefix = "terraform/week7"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
      # ~> 5.0 means: use any 5.x version, but not 6.0+
      # This prevents breaking changes from major version upgrades.
    }
  }
}

# ── Google Provider ───────────────────────────────────────────────────────────
# Configures the Google Cloud provider with your project and region.
#
# project and region come from variables — not hardcoded here.
# This makes the configuration reusable across different projects.
#
# Authentication uses Application Default Credentials (ADC) locally,
# and OIDC token exchange in GitHub Actions — no key file needed either way.
provider "google" {
  project = var.project_id
  region  = var.region
}

# ── Networking Module ─────────────────────────────────────────────────────────
# Calls the child module at ./modules/networking/ and passes it inputs.
#
# source = "./modules/networking"
#   Relative path to the child module directory.
#   terraform init discovers and initializes this module automatically.
#
# The module creates:
#   - 1 VPC network
#   - 1 public subnet (10.0.1.0/24)
#   - 3 firewall rules (allow-ssh, allow-http, deny-all)
#
# After apply, use terraform output to see the VPC name and subnet details.
# These outputs are referenced by Week 8 Cloud Run configuration.
module "networking" {
  source = "./modules/networking"

  project_id  = var.project_id
  region      = var.region
  vpc_name    = "cis410-vpc"   # VPC will be named "cis410-vpc" in GCP
  subnet_cidr = "10.0.1.0/24"  # 256 addresses for application workloads
  my_ip_cidr  = var.my_ip_cidr # your IP — set in terraform.tfvars
}
