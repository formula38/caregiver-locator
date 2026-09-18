# cl-client

Angular 19 standalone app with SSR for the caregiver-locator lab.

## Scripts

```bash
npm install
npm start          # :4200, talks to http://localhost:8500/api
npm run lint
npm run test:ci
npm run build      # production SSR bundle; `/api` is proxied by src/server.ts
```

Set `API_ORIGIN` (default `http://localhost:8500`) when running the Node SSR server so `/api` can reach cl-server.
