---
name: security-hardening-audit
description: >-
  Audit the Vyba codebase (mobile app, admin dashboard, backend) against the
  S0-S21 Security Framework and the F01-F23 findings table in docs/security.md.
  Use when asked to "run a security audit / review", "check the P0/P1 items",
  "is this safe to deploy", before a release or PR merge, or when touching auth,
  tokens, cookies, interceptors, logging, nginx, Docker, AndroidManifest, or CI.
  Produces a report mapping each issue to its F-ID, severity (P0-P3), file:line,
  and fix, plus a done/not-done status for the Security Audit Checklist.
---

# Security hardening audit (Vyba)

The authoritative spec is **`docs/security.md`** (S0-S21, the F01-F23 severity
table, and the P0-P3 Security Audit Checklist). This skill turns it into a
repeatable check. Treat violations the same as design-system violations — flag
before merge.

## How to run

1. **Scope**: default to the current branch diff (`git diff main...HEAD`). For a
   full audit, sweep each sub-project. If invoked from `/security-review`, layer
   these Vyba-specific checks on top.
2. **Check each finding** below with the given command / file, record actual
   status (`FIXED` / `PARTIAL` / `OPEN` / `N/A`), file:line, and the concrete
   fix from the matching `docs/security.md` S-section.
3. **Report** grouped by severity (P0 first), then a checklist table. Do not
   auto-fix unless asked; if asked, fix P0s first and re-verify.
4. Never introduce a regression: adding a token/PII to a log, a `console.log`, a
   permissive cookie, or an `eslint-disable` on a security rule is itself a
   finding.

## Findings checklist

### P0 — block any deployment

| ID | Check | Where / how |
|----|-------|-------------|
| F01 | Mock login accepts any credentials | `Vyba-dashboard-admin/src/features/auth/sign-in/**` — look for `setTimeout(() => navigate('/dashboard'))` with no API call |
| F02 | No `beforeLoad` auth guard | `src/routes/_authenticated/route.tsx` must have `beforeLoad` calling `isTokenExpired` + `redirect({ to: '/sign-in' })`. Also check `settings/route.tsx` and any other `_authenticated/*/route.tsx` |
| F03 | `console.log` leaking form data | `grep -rn "console\.\(log\|debug\|info\)" Vyba-dashboard-admin/src` and `grep -rn "eslint-disable.*no-console" Vyba-dashboard-admin/src` — especially `sign-up-form.tsx` |
| F04 | Cookies without `Secure` / `SameSite` | `src/stores/authStore.ts` `Cookies.set` must pass `{ secure: true, sameSite: 'strict', expires: 7 }` |
| F05 | Hardcoded mock credentials | `grep -rn "test@gmail\|passworD@123\|@gmail.com" Vyba-mobile-app/lib` — currently in `mock_auth_remote_datasource.dart` **and** `presentation/pages/login_page.dart` (dev autofill); must be gated behind `USE_MOCK_AUTH` + a dev-only `assert` |
| F11 | Cleartext HTTP allowed (Android) | `Vyba-mobile-app/android/app/src/main/AndroidManifest.xml` needs `android:usesCleartextTraffic="false"`; base URL assertion `startsWith('https://')` in config/bootstrap |

### P1 — block public launch

| ID | Check | Where / how |
|----|-------|-------------|
| F06 | No certificate pinning in Dio | `Vyba-mobile-app/lib/core/network/dio_client.dart` — `badCertificateCallback` / pinned SPKI hash; `android/app/src/main/res/xml/network_security_config.xml` |
| F07 | No JWT expiry validation before use | Mobile: `auth_interceptor.dart` `onRequest` must check `exp` (30s skew) **before** attaching the token, not rely on 401. Dashboard: `src/lib/jwt-utils.ts` `isTokenExpired` exists — confirm it's called in the route guard and axios request interceptor |
| F08 | nginx has zero security headers | `Vyba-dashboard-admin/nginx.conf` — needs HSTS, CSP (`connect-src` incl. API), `X-Content-Type-Options`, `X-Frame-Options: DENY`, `Referrer-Policy`, `Permissions-Policy`, `server_tokens off`, each with `always` |
| F09 | User profile in plain SharedPreferences | `grep -rn "SharedPreferences\|localStorage" Vyba-mobile-app/lib` for cached `user` — should be `flutter_secure_storage` |
| F10 | LoggingInterceptor logs tokens/passwords | `lib/core/network/interceptors/logging_interceptor.dart` logs `options.data` raw — needs a `LogSanitizer` redacting `password/token/otp/authorization/...`, and gated by `ENABLE_LOGGING` / debug only |
| F11 | HTTPS not enforced in base URL config | `lib/core/config/**` — runtime assertion `baseUrl.startsWith('https://')` |
| F12 | Weak password policy in React | `grep -rn "min(7\|min(6\|\.min(" Vyba-dashboard-admin/src/features/auth` — Zod schema must be min 8 + upper + lower + digit + special (Flutter `Validators.password` already does) |
| — | Axios has no timeout | `src/api/axios-instance.ts` `axios.create` must set `timeout: 30_000` |

### P2 — next sprint

| ID | Check |
|----|-------|
| F13 | Drift DB unencrypted — no `sqlcipher_flutter_libs`, no `PRAGMA key` in `lib/core/database/**` |
| F14 | No root/jailbreak detection at startup (`flutter_jailbreak_detection` / freeRASP) |
| F15/F16 | No CSRF header (`X-Requested-With: XMLHttpRequest` in axios), no reCAPTCHA v3 on auth forms, no 429 backoff in interceptors, no search debounce |
| F17 | No DOMPurify — `grep -rn "dangerouslySetInnerHTML" Vyba-dashboard-admin/src`; `src/lib/sanitize.ts` should exist |
| F18 | CI lacks `pnpm audit --audit-level=high`, gitleaks, CodeQL — check `Vyba-dashboard-admin/.github/workflows/ci.yml` and `Vyba-mobile-app/.github/workflows/ci.yml` (dart: `dart pub outdated`); actions should be SHA-pinned |
| F19 | Sync queue unencrypted — `lib/core/sync/**` stored in plain Drift |
| — | Vite ships source maps — `vite.config.ts` needs `build.sourcemap: false` |
| — | Flutter release not obfuscated — Makefile needs `--obfuscate --split-debug-info` targets |
| — | `android:allowBackup="false"` missing in AndroidManifest |

### P3 — ongoing

| ID | Check |
|----|-------|
| F20 | Docker not distroless / not running as non-root — `Vyba-dashboard-admin/Dockerfile` |
| F21 | 5xx server messages leak to UI — `error_interceptor.dart` `_handleBadResponse` and `src/utils/handle-server-error.ts` must return generic text for `status >= 500` |
| F22 | No `robots.txt` / `.well-known/security.txt` in `Vyba-dashboard-admin/public` |
| F23 | No `.github/dependabot.yml` covering `/Vyba-dashboard-admin` (npm) and `/Vyba-mobile-app` (pub) |

## Cross-cutting checks (S1-S21)

- **S3 injection**: `grep -rn "customStatement" Vyba-mobile-app/lib` (must use
  `Variable()`), `grep -rn "Uri.parse" Vyba-mobile-app/lib` on user input,
  `dangerouslySetInnerHTML` in dashboard.
- **S10 secrets**: `git ls-files | grep -E "\.env$|key\.properties|\.keystore|\.jks|\.p12|google-services\.json|GoogleService-Info\.plist"` must be empty; confirm those patterns are in both `.gitignore` files; no `VITE_`-prefixed secret keys.
- **S12 logging**: no `Authorization` header, request/response body, or PII in any interceptor or crash-report breadcrumb in production.
- **S20 business logic**: OTP attempt cap + cooldown, review requires completed booking, booking expiry, server-validated role changes (`RoleSelectionPage`).

## Known state (verify, may have changed)

- F02: guard present in `src/routes/_authenticated/route.tsx` — confirm it also
  covers nested `route.tsx` files and the axios request interceptor.
- F04: `authStore.ts` currently sets `secure/sameSite/expires` — confirm still true.
- F07 (mobile): `auth_interceptor.dart` still only reacts to 401 in `onError`;
  `onRequest` does **not** pre-validate `exp` — likely OPEN.
- F10: `logging_interceptor.dart` still logs `options.data` raw — likely OPEN.

## Report format

```
## Security audit — <scope> — <date>

### P0 (N open)
- [OPEN] F10 LoggingInterceptor logs raw request bodies
  lib/core/network/interceptors/logging_interceptor.dart:15
  Fix: add LogSanitizer.sanitize(options.data) per docs/security.md S12; gate on ENABLE_LOGGING.
...

### Checklist status
| Item | F-ID | Status |
| Replace mock login | F01 | OPEN |
...
```
