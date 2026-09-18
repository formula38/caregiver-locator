# caregiver-locator

Lab sketch of a caregiver matching site: profiles, matches, reviews, and messages.

System38 maps this under Coldchain / labs. It is not a live product and not IHSS production data.

## Layout

| Path | Stack | State |
| --- | --- | --- |
| `cl-client/` | Angular 19 + SSR (`ng serve` → `:4200`, compose → `:4000`) | Auth, profile, match search, saved matches, reviews, messages |
| `cl-server/` | Lucee 5 / CommandBox JSON API (`:8500`) | Users, profiles, matches, reviews, messages |
| `docker-compose.yml` | Client + server + local Postgres | Local only |
| `infra/gcp/` | Cloud Run, Cloud SQL, Artifact Registry, Secret Manager | Plan-only until the GCP project is confirmed |

## Local

```bash
cp .env.example .env
docker compose up --build
```

- API: `http://localhost:8500/api/health`
- Client: `http://localhost:4000`
- Angular without Docker: `cd cl-client && npm install && npm start` (talks to the API on `:8500`)

Demo password for every seeded account is `password123`. Identities are listed in `cl-server/db/seed.sql`.

Change the compose Postgres password and `JWT_SECRET` before anything leaves loopback.

GCP: copy `infra/gcp/envs/dev/terraform.tfvars.example` and run `terraform plan` only until the target project is confirmed. Do not apply against `sq-partner-nonprod` by accident.

## Do not

- Point this at real caregiver or IHSS member data
- Treat the Angular app as a finished product UI
- Start this stack from the System38 hub
