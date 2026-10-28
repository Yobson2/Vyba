# Deployment

What the repository provides for shipping each app, plus what you must configure
yourself. The repo contains **build artefacts only**: Dockerfiles and standard
framework builds. There is no infrastructure-as-code and no deploy pipeline, and
CI is currently inactive (see [Known limitations](../README.md#known-limitations)).

Before any production release, work through the
[Security Audit Checklist](security.md#security-audit-checklist) in `docs/security.md`.

## Overview

| App | Artefact | Runtime | Port |
|---|---|---|---|
| `Vyba-backend` | `Dockerfile` (multi-stage, Node 20 Alpine) | Node (`node dist/main.js`) | 3000 |
| `Vyba-dashboard-admin` | `Dockerfile` (Node build → nginx Alpine) | nginx serving the SPA | 80 |
| `Vyba-web` | `next build` | Node (`next start`) or Vercel | 3000 by default |
| `vyba-landing-page` | `next build` (fully static pages) | Node (`next start`) or Vercel | 3000 by default |
| `Vyba-mobile-app` | `flutter build appbundle` / `apk` | Google Play | n/a |

## Backend (`Vyba-backend/`)

```bash
cd Vyba-backend
docker build -t vyba-backend .
docker run -p 3000:3000 --env-file .env.production vyba-backend
```

The image sets `NODE_ENV=production` and `RUNNING_IN_DOCKER=true`, and installs
production dependencies only.

**Managed services you need:** PostgreSQL 16, Redis (OTP store, cache and
BullMQ queues), S3-compatible object storage (AWS S3, DigitalOcean Spaces, …),
SMTP, and Firebase credentials for push.

**Database schema:** `synchronize` is enabled only in `development` and `test`
(`src/common/database/database.config.ts`). In production, run migrations
before starting a new version:

```bash
yarn migration:run   # needs dev dependencies (ts-node); run from CI or a builder container
```

The production image doesn't contain `ts-node`, so don't expect to run
migrations from inside the runtime container.

**Required environment** (see `.env.example`): strong unique `JWT_SECRET` /
`JWT_REFRESH_SECRET`, `CORS_ORIGINS` listing only your real front-end origins,
and the `DB_*`, `REDIS_*`, `S3_*` and `MAIL_*` groups. Don't set
`SEED_ADMIN_*` permanently. Use it once to bootstrap the first admin.

> **Blocker:** no real SMS provider exists. In `production` and `staging` the
> backend logs an error and falls back to `FakeSmsProvider`, so OTP login can't
> work for real users until a vendor is integrated (`src/common/sms/`).

## Admin dashboard (`Vyba-dashboard-admin/`)

```bash
cd Vyba-dashboard-admin
docker build -t vyba-dashboard .
docker run -p 8080:80 vyba-dashboard
```

- **Build-time configuration.** `VITE_*` variables are compiled into the bundle
  when `pnpm run build` runs inside the image. The Dockerfile copies the whole
  folder, **including the committed `.env`, whose `VITE_API_URL` points to
  `http://localhost:3000/api`**. Before building for production, override it,
  for example with a `.env.production` file (Vite loads it in production mode).
- **CSP must match the API origin.** `nginx.conf` sends
  `connect-src 'self' https://api.vyba.app`. If the API is served from any
  other origin, update that directive, or every API call will be blocked.
- nginx is already hardened: `server_tokens off`, HSTS, CSP, `X-Frame-Options: DENY`,
  `nosniff`, Referrer and Permissions policies, SPA fallback (`try_files … /index.html`),
  and immutable caching for static assets.

## QR web surface (`Vyba-web/`)

```bash
cd Vyba-web
npm ci && npm run build
npm run start                # or deploy to Vercel
```

Set `API_BASE_URL` (server-side fetches) and `NEXT_PUBLIC_API_BASE_URL`
(browser) to the production API, and add this app's origin to the backend's
`CORS_ORIGINS`. Set `NEXT_PUBLIC_PLAY_STORE_URL` once the Play listing is
public. ADR-0004 sets a performance budget of under 1 s for meaningful content
(2.5 s hard ceiling) on a poor mobile connection. Validate it on a low-end
Android device before launch.

## Landing page (`vyba-landing-page/`)

```bash
cd vyba-landing-page
npm ci && npm run build
npm run start                # or deploy to Vercel
```

Both pages are prerendered (SSG), and the app talks to no API. Set before building:

| Variable | Why |
|---|---|
| `NEXT_PUBLIC_SITE_URL` | Canonical URLs, sitemap and social previews. **Required**; it defaults to `http://localhost:3000` |
| `NEXT_PUBLIC_PLAY_STORE_URL` | Turns the "Bientôt sur Google Play" state into a real link |
| `NEXT_PUBLIC_WHATSAPP_NUMBER` | Enables the venue-owner WhatsApp CTA |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Optional contact on the privacy page |

Security headers (HSTS, `frame-ancestors 'none'`, nosniff, Referrer and
Permissions policies) are set in `next.config.ts`. The privacy page carries a
`TODO(legal)` and needs a legal review before the public launch.

## Mobile app (`Vyba-mobile-app/`)

Distribution is **Android-first through Google Play**: a closed testing track
for the founding cohort, then production. iOS goes through TestFlight only if
needed (spec §15). Sideloaded APKs are not the validation channel.

```bash
cd Vyba-mobile-app
cp .env.example .env         # then set production values (HTTPS BASE_URL, see below)
flutter build appbundle --release
```

Release checklist:

- `USE_MOCK_AUTH=false` and `ENABLE_LOGGING=false` in the bundled `.env`.
- `BASE_URL` uses HTTPS, with no cleartext fallback.
- Signing keys and keystore passwords live outside the repository.
- See `docs/security.md` §S11 for obfuscated release builds.

## Production checklist

- [ ] Real SMS provider integrated (OTP login)
- [ ] Unique JWT secrets, real `CORS_ORIGINS`, HTTPS everywhere
- [ ] Backend migrations run before rollout
- [ ] Dashboard built with the production `VITE_API_URL`, and the nginx CSP `connect-src` matches it
- [ ] `NEXT_PUBLIC_SITE_URL` set for the landing page; QR web API URLs set
- [ ] Mobile: `USE_MOCK_AUTH=false`, logging off, HTTPS `BASE_URL`
- [ ] Privacy page reviewed by counsel
- [ ] Security audit checklist completed ([`security.md`](security.md#security-audit-checklist))
