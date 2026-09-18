terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.40.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "caregiver_locator" {
  source               = "../../modules/caregiver_locator"
  project_id           = var.project_id
  region               = var.region
  name_prefix          = var.name_prefix
  server_image         = var.server_image
  client_image         = var.client_image
  cors_allowed_origins = var.cors_allowed_origins
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "name_prefix" {
  type    = string
  default = "cl"
}

variable "server_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "client_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "cors_allowed_origins" {
  type    = string
  default = "http://localhost:4000"
}

output "artifact_registry" { value = module.caregiver_locator.artifact_registry }
output "server_url" { value = module.caregiver_locator.server_url }
output "client_url" { value = module.caregiver_locator.client_url }
output "sql_connection_name" { value = module.caregiver_locator.sql_connection_name }
