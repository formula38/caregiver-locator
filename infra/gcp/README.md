# GCP

Plan-only until the target project is confirmed. Current local `gcloud` project may be unrelated.

```bash
cd infra/gcp/envs/dev
cp terraform.tfvars.example terraform.tfvars
# fill project_id and image URIs
terraform init
terraform plan
```

Images are built by `deploy/cloudbuild.yaml` into Artifact Registry (`cl-apps`). Cloud Run runs cl-server with a Cloud SQL Auth Proxy sidecar on `127.0.0.1:5432`.
