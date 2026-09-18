output "artifact_registry" {
  value = google_artifact_registry_repository.apps.id
}

output "server_url" {
  value = google_cloud_run_v2_service.server.uri
}

output "client_url" {
  value = google_cloud_run_v2_service.client.uri
}

output "sql_connection_name" {
  value = google_sql_database_instance.main.connection_name
}
