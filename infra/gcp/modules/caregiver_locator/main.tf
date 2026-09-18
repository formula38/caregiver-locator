locals {
  labels = {
    product     = "caregiver-locator"
    environment = "lab"
  }
  db_name = "caregiver_locator"
}

resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "apps" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.name_prefix}-apps"
  description   = "caregiver-locator container images"
  format        = "DOCKER"
  labels        = local.labels
  depends_on    = [google_project_service.apis]
}

resource "google_sql_database_instance" "main" {
  name             = "${var.name_prefix}-sql"
  project          = var.project_id
  region           = var.region
  database_version = "POSTGRES_16"

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled = true
    }
    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
  depends_on          = [google_project_service.apis]
}

resource "google_sql_database" "app" {
  name     = local.db_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "random_password" "db" {
  length  = 24
  special = false
}

resource "random_password" "jwt" {
  length  = 48
  special = false
}

resource "google_sql_user" "app" {
  name     = "cl_app"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
  password = random_password.db.result
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "${var.name_prefix}-db-password"
  replication {
    auto {}
  }
  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db.result
}

resource "google_secret_manager_secret" "jwt" {
  project   = var.project_id
  secret_id = "${var.name_prefix}-jwt-secret"
  replication {
    auto {}
  }
  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "jwt" {
  secret      = google_secret_manager_secret.jwt.id
  secret_data = random_password.jwt.result
}

resource "google_service_account" "server" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-server"
  display_name = "cl-server Cloud Run"
}

resource "google_service_account" "client" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-client"
  display_name = "cl-client Cloud Run"
}

resource "google_project_iam_member" "server_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.server.email}"
}

resource "google_secret_manager_secret_iam_member" "server_db" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.server.email}"
}

resource "google_secret_manager_secret_iam_member" "server_jwt" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.jwt.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.server.email}"
}

resource "google_cloud_run_v2_service" "server" {
  name     = "${var.name_prefix}-server"
  project  = var.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.server.email

    containers {
      name  = "app"
      image = var.server_image
      ports {
        container_port = 8080
      }
      env {
        name  = "PORT"
        value = "8080"
      }
      env {
        name  = "POSTGRES_HOST"
        value = "127.0.0.1"
      }
      env {
        name  = "POSTGRES_PORT"
        value = "5432"
      }
      env {
        name  = "POSTGRES_DB"
        value = local.db_name
      }
      env {
        name  = "POSTGRES_USER"
        value = google_sql_user.app.name
      }
      env {
        name = "POSTGRES_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password.secret_id
            version = "latest"
          }
        }
      }
      env {
        name = "JWT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.jwt.secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "CORS_ALLOWED_ORIGINS"
        value = var.cors_allowed_origins
      }
      env {
        name  = "APP_ENV"
        value = "production"
      }
      env {
        name  = "SEED_DEMO_DATA"
        value = "true"
      }
      depends_on = ["cloud-sql-proxy"]
      startup_probe {
        http_get {
          path = "/api/health"
          port = 8080
        }
        period_seconds    = 10
        failure_threshold = 18
      }
    }

    containers {
      name  = "cloud-sql-proxy"
      image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.14.3"
      args = [
        "--structured-logs",
        "--port=5432",
        google_sql_database_instance.main.connection_name,
      ]
      startup_probe {
        timeout_seconds   = 1
        period_seconds    = 1
        failure_threshold = 20
        tcp_socket {
          port = 5432
        }
      }
    }
  }

  depends_on = [google_project_service.apis]
}

resource "google_cloud_run_v2_service" "client" {
  name     = "${var.name_prefix}-client"
  project  = var.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.client.email
    containers {
      name  = "app"
      image = var.client_image
      ports {
        container_port = 4000
      }
      env {
        name  = "PORT"
        value = "4000"
      }
      env {
        name  = "API_ORIGIN"
        value = google_cloud_run_v2_service.server.uri
      }
    }
  }

  depends_on = [google_cloud_run_v2_service.server]
}

resource "google_cloud_run_v2_service_iam_member" "server_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.server.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "client_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.client.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
