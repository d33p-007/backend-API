# terraform/week7/modules/networking/main.tf
# ─────────────────────────────────────────────────────────────────────────────
# Networking child module — creates VPC, subnet, and firewall rules.
#
# This module is called by the root module (terraform/week7/main.tf).
# It does not have a backend block or provider block — those belong
# in the root module only.
#
# Resources created:
#   google_compute_network.vpc           — the VPC network
#   google_compute_subnetwork.public     — one public subnet
#   google_compute_firewall.allow_ssh    — SSH from your IP only
#   google_compute_firewall.allow_http   — HTTP/8080 from anywhere
#   google_compute_firewall.deny_all_ingress — explicit deny-all fallback
# ─────────────────────────────────────────────────────────────────────────────


# ── VPC Network ───────────────────────────────────────────────────────────────
# A VPC (Virtual Private Cloud) is your private network inside GCP.
# auto_create_subnetworks = false means we define subnets manually.
# This is best practice — auto subnets create one subnet per GCP region
# automatically, which is unnecessary and hard to control.
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id

  description = "CIS 410 course VPC — managed by Terraform Week 7"
}


# ── Public Subnet ─────────────────────────────────────────────────────────────
# A subnet is a range of IP addresses within the VPC.
# Resources deployed here (Cloud Run, VMs) receive IPs from this range.
#
# network = google_compute_network.vpc.id is a resource reference.
# Terraform reads the VPC's id after creating it and passes it here.
# This creates an implicit dependency — Terraform creates the VPC first,
# then the subnet. No "depends_on" needed.
resource "google_compute_subnetwork" "public" {
  name          = "${var.vpc_name}-public"  # e.g. "cis410-vpc-public"
  ip_cidr_range = var.subnet_cidr           # e.g. "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

  description = "Application workload subnet — used by Cloud Run in Week 8"
}


# ── Firewall Rule 1: Allow SSH from your IP only ──────────────────────────────
# SSH (port 22) is restricted to your specific public IP address.
#
# source_ranges = [var.my_ip_cidr]
#   var.my_ip_cidr is "YOUR_IP/32" — the /32 means exactly one IP address.
#   Only your machine can initiate SSH connections into this VPC.
#
# target_tags = ["ssh-enabled"]
#   This rule only applies to VMs tagged "ssh-enabled".
#   Resources without this tag are unaffected by the rule.
#
# SECURITY: Never use "0.0.0.0/0" on port 22. That exposes the server
# to brute-force attempts from every IP address on the internet.
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_cidr]  # your IP only — set in terraform.tfvars
  target_tags   = ["ssh-enabled"]
  description   = "Allow SSH from operator IP only — not 0.0.0.0/0"
}


# ── Firewall Rule 2: Allow HTTP from the internet ─────────────────────────────
# Web traffic (ports 80 and 8080) is allowed from anywhere.
#
# source_ranges = ["0.0.0.0/0"]
#   This is intentional for HTTP — web servers must be publicly reachable.
#
# target_tags = ["web-server"]
#   The rule only applies to resources tagged "web-server".
#   A database VM without this tag is not affected.
#   When you deploy to Cloud Run in Week 8, you will apply this tag.
resource "google_compute_firewall" "allow_http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]   # any IP — intentional for web traffic
  target_tags   = ["web-server"]
  description   = "Allow HTTP and 8080 traffic to web-tagged resources"
}


# ── Firewall Rule 3: Explicit deny-all ingress fallback ───────────────────────
# GCP blocks all inbound traffic by default, but making this explicit in code
# serves two purposes:
#   1. Documents intent — "we consciously block everything not listed above"
#   2. Protects against future GCP default policy changes
#
# priority = 65000
#   Lower number = higher priority. Default priority for allow rules is 1000.
#   Allow rules at priority 1000 always win over this deny at priority 65000.
#   Everything not matched by allow-ssh or allow-http is blocked here.
#
# direction = "INGRESS"
#   This rule only applies to inbound traffic (traffic coming into the VPC).
resource "google_compute_firewall" "deny_all_ingress" {
  name      = "${var.vpc_name}-deny-ingress"
  network   = google_compute_network.vpc.name
  project   = var.project_id
  priority  = 65000
  direction = "INGRESS"

  deny {
    protocol = "all"  # block all protocols (TCP, UDP, ICMP, etc.)
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Explicit deny-all fallback — blocks traffic not matched above"
}
