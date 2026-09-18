variable "project_id" {
  type        = string
  description = "GCP project for the caregiver-locator lab. Confirm before apply; this module is plan-only until then."
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "name_prefix" {
  type        = string
  default     = "cl"
  description = "Short prefix for resource names."
}

variable "server_image" {
  type        = string
  description = "Artifact Registry image for cl-server."
}

variable "client_image" {
  type        = string
  description = "Artifact Registry image for cl-client."
}

variable "db_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "cors_allowed_origins" {
  type        = string
  default     = "http://localhost:4000"
  description = "Comma-separated browser origins allowed by cl-server."
}
