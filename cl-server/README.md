# cl-server

Lucee 5 JSON API for the caregiver-locator lab. CommandBox serves the app; Angular is the only UI.

## Shape

- `index.cfm` + `config/Router.cfc` — front controller. Adobe REST CFCs are gone.
- `handlers/` — HTTP parse, validate, respond
- `services/` — business rules and `queryExecute`
- `lib/` — password hashing (PBKDF2), JWT (`jwt-cfml`), JSON envelopes

## Run

From the repo root:

```bash
cp .env.example .env
docker compose up --build db server
```

`GET /api/health` should return `{ "ok": true, "data": { "status": "ok" } }`.

The CommandBox image runs as its default user; its entrypoint needs write access under `/usr/local/lib/CommandBox`.

Tests: `curl "http://localhost:8500/tests/runner.cfm?reporter=text"` after the server is up.

## Auth

Protected routes expect `Authorization: Bearer <jwt>`. Message `senderId` and review `reviewerId` come from the token, not the body.
