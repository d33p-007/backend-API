# terraform/modules/networking/main.tf
# Creates the VPC, public subnet, and firewall rules for the capstone project.

# ── VPC Network ───────────────────────────────────────────────────────────────
# auto_create_subnetworks = false so subnets are defined explicitly below.
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
  description             = "CIS 410 capstone VPC"
}

# ── Public Subnet ─────────────────────────────────────────────────────────────
# Resources deployed here (Cloud Run, VMs) receive IPs from this CIDR range.
# Implicit dependency on the VPC — Terraform creates the VPC first.
resource "google_compute_subnetwork" "public" {
  name          = "${var.vpc_name}-public"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  description   = "Application workload subnet"
}

# ── Firewall: Allow SSH from operator IP only ─────────────────────────────────
# Restricts port 22 to a single /32 IP (set in terraform.tfvars).
# Only applies to VMs tagged "ssh-enabled".
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_cidr]
  target_tags   = ["ssh-enabled"]
  description   = "Allow SSH from operator IP only"
}

# ── Firewall: Allow HTTP/8080 from anywhere ───────────────────────────────────
# Public web traffic on ports 80 and 8080.
# Only applies to resources tagged "web-server".
resource "google_compute_firewall" "allow_http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
  description   = "Allow HTTP and 8080 traffic to web-tagged resources"
}

# ── Firewall: Deny-all ingress fallback ───────────────────────────────────────
# Priority 65000 — lower priority than the allow rules above (default 1000),
# so allow rules always win. Blocks all traffic not explicitly permitted.
resource "google_compute_firewall" "deny_all_ingress" {
  name      = "${var.vpc_name}-deny-ingress"
  network   = google_compute_network.vpc.name
  project   = var.project_id
  priority  = 65000
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Explicit deny-all fallback — blocks traffic not matched above"
}
