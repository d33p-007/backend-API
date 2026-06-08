# terraform/modules/networking/variables.tf
# Input variables passed in by the root module (infrastructure/main.tf).

variable "project_id" {
  description = "GCP project ID where all resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region for the subnet"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name prefix for the VPC and all networking resources (e.g. 'cis410-capstone-vpc')"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet (e.g. '10.0.1.0/24')"
  type        = string
}

variable "my_ip_cidr" {
  description = "Operator public IP in CIDR notation for SSH access (e.g. '203.0.113.45/32')"
  type        = string
}
