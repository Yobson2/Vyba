# Local development setup

A step-by-step guide to running Vyba on your machine. Each app is independent,
so you only need to start what you're working on. Start the backend first,
though, because everything except the landing page depends on it.

## Prerequisites

| Tool | Version | Used by |
|---|---|---|
| Node.js | 20 (the version the Dockerfiles and CI use) | backend, dashboard, QR web, landing |
| yarn | 1.x | backend |
| pnpm | any recent | dashboard |
| npm | bundled with Node | QR web, landing |
| Docker + Docker Compose | any recent | backend infrastructure |
| Flutter SDK | stable channel (Dart ≥ 3.6.1) | mobile app |
| Android SDK / emulator | n/a | mobile app (Android-first) |

## Ports at a glance

| Service | URL | Configured in |
|---|---|---|
| Backend API | http://localhost:3000 | `Vyba-backend/.env` → `PORT` |
| Swagger UI | http://localhost:3000/api/docs | `Vyba-backend/src/main.ts` |
| PostgreSQL | localhost:5432 | `DB_PORT` |
| Redis | localhost:6379 | `REDIS_PORT` |
| MinIO (S3 API / console) | http://localhost:9000 · http://localhost:9001 | `docker-compose.yml` |
| Adminer (DB UI) | http://localhost:8080 | `docker-compose.yml` |
| Admin dashboard | http://localhost:5173 | Vite default |
| QR web surface | http://localhost:3001 | `Vyba-web/package.json` (`next dev -p 3001`) |
| Landing page | http://localhost:3002 (suggested) | `npm run dev -- -p 3002` |

> The landing page defaults to port **3000**, which clashes with the backend.
> Pass `-p 3002` (or any free port) when both are running.

## 1. Backend (`Vyba-backend/`)

```bash
cd Vyba-backend
cp .env.example .env
yarn install
docker compose up -d     # PostgreSQL 16, Redis 7, MinIO, Adminer
yarn start:dev           # hot reload on http://localhost:3000
```

Then edit `.env`:

- **JWT secrets**: replace `JWT_SECRET` and `JWT_REFRESH_SECRET`, for example
  with `openssl rand -base64 48`.
- **CORS**: `CORS_ORIGINS` already allows `:3000`, `:4200` and `:5173`. Add
  `http://localhost:3001` for the QR web surface.
- **First admin account (optional)**: set `SEED_ADMIN_EMAIL` and
  `SEED_ADMIN_PASSWORD`. These aren't in `.env.example`. On startup the backend
  creates that admin once and skips it on later runs
  (`src/modules/auth/admin-seed.service.ts`). Use it to sign in to the dashboard.
- **Docker-aware config**: when the API itself runs inside Docker,
  `RUNNING_IN_DOCKER=true` (or the presence of `/.dockerenv`) switches the config
  loader to container hostnames (`src/common/config/environment.loader.ts`).

The schema auto-syncs in development. For production-style migrations:

```bash
yarn migration:generate   # generate from entity changes
yarn migration:run
yarn migration:revert
```

The S3 bucket (`S3_BUCKET`, default `app-storage`) is created on first use if it
doesn't exist. Default MinIO credentials are `minioadmin` / `minioadmin` (dev only).

### Phone sign-in during development

No real SMS provider is integrated. Codes are captured by `FakeSmsProvider`
(`src/common/sms/fake-sms.provider.ts`), which keeps them in memory for tests and
doesn't print them. In practice:

- **Mobile UI work:** set `USE_MOCK_AUTH=true` in `Vyba-mobile-app/.env` to use
  the mock auth data source. Development only; it must be `false` anywhere else.
- **Backend auth logic:** use the test suite, which reads codes from the fake provider.

## 2. Admin dashboard (`Vyba-dashboard-admin/`)

```bash
cd Vyba-dashboard-admin
cp .env.example .env      # VITE_API_URL=http://localhost:3000/api
pnpm install
pnpm dev                  # http://localhost:5173
```

Sign in with the seeded admin from step 1. `VITE_*` variables are embedded in
the client bundle, so put public configuration only there. Adding a route
regenerates the TanStack route tree automatically. More detail is in
[`dashboard.md`](dashboard.md).

## 3. QR web surface (`Vyba-web/`)

```bash
cd Vyba-web
cp .env.example .env.local
npm install
npm run dev               # http://localhost:3001
```

Set `API_BASE_URL` and `NEXT_PUBLIC_API_BASE_URL` to the backend URL. Pages are
`/<venueId>` (venue night) and `/zone4` (public feed). `NEXT_PUBLIC_PLAY_STORE_URL`
is optional: the app-download prompt doesn't render without it.

## 4. Mobile app (`Vyba-mobile-app/`)

```bash
cd Vyba-mobile-app
cp .env.example .env
make get                  # flutter pub get
make gen                  # code generation (freezed, json_serializable, riverpod)
make run                  # flutter run
```

- `BASE_URL` defaults to `http://localhost:3000`. On an **Android emulator**,
  `localhost` is the emulator itself, so use `http://10.0.2.2:3000` to reach
  your machine.
- Re-run `make gen` after editing any `@freezed`, `@JsonSerializable` or
  `@riverpod` class. `make watch` keeps it running.
- Architecture, routing and lint rules: [`mobile.md`](mobile.md).

## 5. Landing page (`vyba-landing-page/`)

Static marketing site, no backend required.

```bash
cd vyba-landing-page
cp .env.example .env.local   # optional; all values are public
npm install
npm run dev -- -p 3002
```

Leave `NEXT_PUBLIC_PLAY_STORE_URL` or `NEXT_PUBLIC_WHATSAPP_NUMBER` unset and
the CTAs render a "bientôt" state instead of a link.

## Running tests

| App | Command | What runs |
|---|---|---|
| Backend | `yarn test` · `yarn test:e2e` · `yarn test:cov` | Jest unit tests (`*.spec.ts`) and e2e (`test/jest-e2e.json`) |
| Dashboard | `pnpm test` | Vitest |
| QR web | `npm test` | Vitest with an MSW-mocked API, the project's single test seam |
| Mobile | `make test` · `make integration` | `flutter test` (mocktail) and `integration_test/` (robot pattern) |
| Landing | `npm run lint` · `npm run typecheck` | No test suite. Lint and types only |

## Quality checks before pushing

```bash
# backend
yarn lint && yarn test
# dashboard
pnpm lint && pnpm build          # build runs tsc -b
# QR web
npm run lint && npm test
# mobile
make analyze && make test && dart format --set-exit-if-changed .
# landing
npm run lint && npm run typecheck && npm run build
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `EADDRINUSE :3000` | The backend and the landing page both default to 3000. Start the landing page with `-p 3002` |
| Browser CORS error from the QR web or dashboard | Add its origin to `CORS_ORIGINS` in `Vyba-backend/.env` and restart the API |
| Mobile app can't reach the API on an emulator | Use `http://10.0.2.2:3000` for `BASE_URL` |
| Dart errors about missing `*.g.dart` / `*.freezed.dart` | Run `make gen` |
| OTP never arrives | Expected: no SMS provider yet (see above) |
