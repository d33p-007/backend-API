variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
  default     = "cis410-capstone-vpc"
}

variable "db_password" {
  description = "Cloud SQL postgres user password"
  type        = string
  sensitive   = true
}

variable "flask_secret_key" {
  description = "Flask SECRET_KEY"
  type        = string
  sensitive   = true
}

variable "jwt_secret_key" {
  description = "JWT_SECRET_KEY"
  type        = string
  sensitive   = true
}