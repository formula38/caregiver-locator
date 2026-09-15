# caregiver-locator

Lab sketch of a caregiver matching site: profiles, matches, reviews, and messages.

System38 maps this under Coldchain / labs. It is not a live product and not IHSS production data.

## Layout

| Path | Stack | State |
| --- | --- | --- |
| `cl-client/` | Angular 19 + SSR (`ng serve` → `:4200`) | Still the CLI scaffold (`title = 'cl-client'`) |
| `cl-server/` | CFML (ColdFusion/Lucee-style) handlers, models, and API CFC files | Matching, profiles, reviews, users, messages |
| `cl-server/docker/` | Compose: app on `:8500` plus local Postgres | Local only |

Client README is the Angular CLI default. Server root README is empty — this file is the map.

## Local

```bash
cd cl-client
npm install
npm start
```

Server compose lives under `cl-server/docker/`. Change the compose Postgres credentials before anything leaves loopback.

## Do not

- Point this at real caregiver or IHSS member data
- Treat the Angular app as finished UI
- Start this stack from the System38 hub
