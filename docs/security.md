# Security Framework — Vyba Production Hardening

These rules are **hard constraints** for all code across the three sub-projects.
Treat a violation the same as a design-system violation — fix before merge.
`CLAUDE.md` carries the always-true short version; this file is the full spec.

## How to use this document

- This is the **target state and the rationale** for each control, not a
  point-in-time TODO list. Some items are already implemented.
- The **`security-hardening-audit` skill** checks the current codebase against
  this framework and reports per-finding status (`FIXED` / `PARTIAL` / `OPEN`).
  Run it rather than trusting the S0 table or the checklist below verbatim.
- Code samples are reference implementations — adapt to the code as it actually
  is, keeping the property being enforced.

## Status notes (verify with the audit skill)

- **F01** — resolved. `UserAuthForm` now calls the real
  `POST /api/auth/admin/login`; see S4.
- **F02** — a `beforeLoad` guard already exists on
  `src/routes/_authenticated/route.tsx`. Confirm it also covers nested
  `route.tsx` files and the Axios request interceptor.
- **F04** — `src/stores/authStore.ts` already sets
  `{ secure: true, sameSite: 'strict', expires: 7 }`. Confirm still true.
- **F05** — the mock credentials also appear in
  `lib/features/auth/presentation/pages/login_page.dart` (dev autofill), not only
  the mock datasource.
- **S1 (dashboard)** — `src/lib/jwt-utils.ts` already exists.
- **F07 (mobile)** — `auth_interceptor.dart` still only reacts to 401 in
  `onError`; `onRequest` does not pre-validate `exp`. Likely OPEN.
- **F10** — `logging_interceptor.dart` still logs `options.data` raw. Likely OPEN.
- **S19** — no AI features exist in the repo yet; the section is forward-looking.

---

### S0. Severity Classification

| ID | Finding | Project | Severity |
|----|---------|---------|----------|
| F01 | Mock login accepts ANY credentials | Dashboard | **P0** |
| F02 | No `beforeLoad` auth guard on protected routes | Dashboard | **P0** |
| F03 | `console.log(data)` leaks passwords in sign-up form | Dashboard | **P0** |
| F04 | Cookies set without `Secure`/`SameSite` flags | Dashboard | **P0** |
| F05 | Mock credentials hardcoded in source (`test@gmail.com`) | Mobile | **P0** |
| F06 | No certificate pinning in Dio | Mobile | **P1** |
| F07 | No JWT expiry validation in either app | Both | **P1** |
| F08 | nginx.conf has zero security headers | Dashboard | **P1** |
| F09 | User profile cached in plain SharedPreferences | Mobile | **P1** |
| F10 | LoggingInterceptor logs tokens and passwords | Mobile | **P1** |
| F11 | HTTP accepted in base URL config (no HTTPS enforcement) | Mobile | **P1** |
| F12 | Password validation only 7 chars, no complexity | Dashboard | **P1** |
| F13 | Drift SQLite database unencrypted | Mobile | **P2** |
| F14 | No root/jailbreak detection | Mobile | **P2** |
| F15 | No CSRF protection | Dashboard | **P2** |
| F16 | No rate limiting anywhere | Both | **P2** |
| F17 | No DOMPurify for user-generated content | Dashboard | **P2** |
| F18 | No security scanning in CI | Both | **P2** |
| F19 | Sync queue stored unencrypted | Mobile | **P2** |
| F20 | Docker image not distroless | Dashboard | **P3** |
| F21 | Server error messages leak to UI | Both | **P3** |
| F22 | No security.txt or robots.txt | Dashboard | **P3** |
| F23 | No Dependabot/Renovate configured | Both | **P3** |

---

### S1. Zero Trust & Least Privilege

**Why**: No request should be implicitly trusted — not from authenticated users, not from the local device.

**Rules**:

- **Flutter**: Validate JWT expiry in `AuthInterceptor.onRequest` BEFORE attaching the token. If expired, trigger refresh. Never trust client-side `UserRole` for authorization — it's a UX hint only; the server must re-validate on every request.

```dart
// In AuthInterceptor.onRequest — add before setting Authorization header
bool _isTokenExpired(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return true;
    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    ) as Map<String, dynamic>;
    final exp = payload['exp'] as int?;
    if (exp == null) return true;
    // 30-second buffer for clock skew
    return DateTime.now().millisecondsSinceEpoch / 1000 >= exp - 30;
  } catch (_) {
    return true;
  }
}
```

- **React**: Add `beforeLoad` guard on `_authenticated` route layout. Never rely on UI-only protection.

```typescript
// src/routes/_authenticated/route.tsx
export const Route = createFileRoute('/_authenticated')({
  beforeLoad: ({ location }) => {
    const { accessToken } = useAuthStore.getState().auth;
    if (!accessToken || isTokenExpired(accessToken)) {
      useAuthStore.getState().auth.reset();
      throw redirect({ to: '/sign-in', search: { redirect: location.href } });
    }
  },
  component: AuthenticatedLayout,
});

// src/lib/jwt-utils.ts
export function isTokenExpired(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return Date.now() / 1000 >= (payload.exp ?? 0) - 30;
  } catch {
    return true;
  }
}
```

**Mistakes to avoid**:
- Relying only on 401 responses to detect expired tokens (request already sent with stale auth)
- Checking auth state only in UI components, not at route level
- Trusting `UserRole` from cached local storage without server re-verification

---

### S2. OWASP Top 10 Mapping

| OWASP 2021 | Framework Section(s) |
|------------|---------------------|
| A01 Broken Access Control | S1, S4, S20 |
| A02 Cryptographic Failures | S16 |
| A03 Injection | S3, S9 |
| A04 Insecure Design | S1, S20, S21 |
| A05 Security Misconfiguration | S7, S10, S17 |
| A06 Vulnerable Components | S14 |
| A07 Auth Failures | S4, S5 |
| A08 Data Integrity Failures | S14, S15 |
| A09 Logging & Monitoring | S12, S13 |
| A10 SSRF | S3, S6 |

---

### S3. Injection Prevention (XSS, CSRF, CSP, SSRF, SQLi)

**Why**: User-generated content (reviews, venue names, feed posts) is rendered in both apps. The dashboard serves HTML via nginx with no CSP.

**Rules**:

- **XSS (React)**: Install `dompurify`. Sanitize all user-generated HTML before rendering. Never use `dangerouslySetInnerHTML` without sanitization.

```typescript
// src/lib/sanitize.ts
import DOMPurify from 'dompurify';

export function sanitizeHtml(dirty: string): string {
  return DOMPurify.sanitize(dirty, { ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a', 'p', 'br'], ALLOWED_ATTR: ['href'] });
}
```

- **XSS (Flutter)**: Flutter's widget tree is not HTML-based — traditional XSS is mitigated. If `WebView` is used, sandbox JavaScript. Never render user content via `dart:html`.

- **CSRF (React)**: Set cookies with `SameSite=Strict`. Add `X-Requested-With: XMLHttpRequest` header to all Axios requests.

```typescript
// In axios-instance.ts headers
headers: { 'X-Requested-With': 'XMLHttpRequest' }
```

- **CSP (nginx)**: See S7 for full header. Minimum: `default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https://api.vyba.app; frame-ancestors 'none'`.

- **SSRF**: Never pass user-supplied URLs directly to server-side fetches. Validate URL schemes (`https://` only). For image URLs from API, allowlist CDN domains.

- **SQLi (Drift)**: Drift uses parameterized queries by default. **Never** use `customStatement()` with string concatenation. Always use `Variable()`.

```dart
// SAFE
select(notes)..where((n) => n.title.like(Variable('%$query%')));

// UNSAFE — never do this
customStatement('SELECT * FROM notes WHERE title LIKE "%$query%"');
```

**Mistakes to avoid**:
- Using `innerHTML` or `dangerouslySetInnerHTML` for review/feed content
- Forgetting `script-src` defaults to `unsafe-inline` without explicit CSP
- Passing user input to `Uri.parse()` without scheme validation in Flutter

---

### S4. Authentication & Session Security

**Why**: Both apps handle sensitive auth flows (phone+OTP, email/password, JWT sessions).

**Rules**:

- **Dashboard admin auth** (implemented): `UserAuthForm` calls the real
  `POST /api/auth/admin/login` (email+password — the one exemption ADR-0003
  allows for this internal-only surface). Passwords are bcrypt-hashed and
  stored on a separate `AdminCredential` entity, kept off the phone-OTP
  `User` table. A bootstrap admin is created on boot only when
  `SEED_ADMIN_EMAIL`/`SEED_ADMIN_PASSWORD` are set and no credential for that
  email exists yet (`AdminSeedService`) — **never hardcoded, never
  re-applied once changed**. `PATCH /api/auth/admin/password` (ADMIN-only,
  requires the current password) rotates it — do this immediately after
  first login, then unset the env vars.

- **Dashboard — secure cookie flags** (P0):

```typescript
// src/stores/authStore.ts — fix setAccessToken
Cookies.set(ACCESS_TOKEN, JSON.stringify(accessToken), {
  secure: true,           // HTTPS only
  sameSite: 'strict',     // CSRF protection
  expires: 7,             // 7-day expiry
});
```

Note: `HttpOnly` cannot be set from JavaScript. If the API returns tokens via `Set-Cookie`, ensure the API sets `HttpOnly; Secure; SameSite=Strict`.

- **Dashboard — remove console.log** (P0): Delete `console.log(data)` from `sign-up-form.tsx`. The ESLint `no-console` rule exists but is overridden with `eslint-disable-next-line`. Remove those overrides.

- **Password policy** (P1): Both apps must enforce min 8 chars, 1 upper, 1 lower, 1 digit, 1 special char. Flutter `Validators.password` already does this. Update React:

```typescript
// Shared Zod password schema
const passwordSchema = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Must contain at least one uppercase letter')
  .regex(/[a-z]/, 'Must contain at least one lowercase letter')
  .regex(/[0-9]/, 'Must contain at least one digit')
  .regex(/[^A-Za-z0-9]/, 'Must contain at least one special character');
```

- **Flutter — session timeout**: Implement auto-logout after 30 minutes idle. Clear all auth state on logout (tokens, cached user, database).

- **Flutter — mock auth gating** (P0): Ensure `USE_MOCK_AUTH` defaults to `false`. Guard mock datasource registration:

```dart
// In auth providers — only register mock if explicitly enabled
final isUseMockAuth = env.useMockAuth; // reads USE_MOCK_AUTH from .env
// Production builds should NEVER have USE_MOCK_AUTH=true
assert(!isUseMockAuth || env.isDevelopment, 'Mock auth forbidden outside development');
```

**Mistakes to avoid**:
- Storing tokens in `localStorage` (XSS-accessible; use cookies or secure storage)
- Not revoking refresh tokens server-side on logout
- Shipping APK with `USE_MOCK_AUTH=true`
- Leaving `eslint-disable` comments that suppress security-relevant rules

---

### S5. JWT Security

**Why**: JWTs are the auth mechanism for API communication in both apps. Neither currently validates expiry before use.

**Rules**:

- Always validate `exp` claim before using token. If expired, trigger refresh flow (see S1 for code).
- Never decode JWT on client for **authorization** decisions — use it only for UX hints (e.g., displaying user name). Server must re-validate on every request.
- Refresh token rotation: after refresh, old refresh token must be invalidated server-side.
- Recommended TTLs: access token 15 minutes, refresh token 7 days.
- Add 30-second clock skew buffer to expiry checks (see S1 code).
- **Never log JWT tokens** in any interceptor (see S12).

**Mistakes to avoid**:
- Storing decoded JWT claims as source of truth for permissions
- Not handling clock skew between client and server
- Logging JWT tokens in request/response interceptors
- Using symmetric signing (HS256) for tokens shared across services — use RS256/ES256

---

### S6. API Security & Rate Limiting

**Why**: The external API is the primary attack surface. Neither app enforces HTTPS or pins certificates.

**Rules**:

- **HTTPS enforcement (Flutter)** (P1): Validate base URL at startup.

```dart
// In AppConfig or bootstrap
assert(baseUrl.startsWith('https://'), 'HTTPS required for API base URL');
```

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="false"
    ...>
```

- **Certificate pinning (Flutter)** (P1): Pin the API domain's public key.

```dart
// In DioClient.create — add after creating Dio instance
(dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    // Compare cert.ppiFingerprint with pinned hash
    final validHosts = ['api.vyba.app', 'api-staging.vyba.app'];
    if (!validHosts.contains(host)) return false;
    // Pin SHA-256 of Subject Public Key Info
    final pinnedHash = 'YOUR_BASE64_SHA256_HASH_HERE';
    return sha256OfCert(cert) == pinnedHash;
  };
  return client;
};
```

- **Rate limiting**: Client-side debounce on search inputs. Handle 429 responses with exponential backoff in both interceptors.

- **Request timeout (Dashboard)**: Add timeout to Axios (currently missing):

```typescript
// src/api/axios-instance.ts
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? '/api',
  timeout: 30_000, // 30 seconds
});
```

**Mistakes to avoid**:
- Falling back to HTTP in development (use self-signed cert for local dev instead)
- Pinning leaf certificates (pin intermediate or root CA instead — leaf certs rotate)
- Not rate-limiting OTP verification endpoint (brute-force risk)
- Setting `android:usesCleartextTraffic="true"` for debug convenience

---

### S7. Security Headers & CORS

**Why**: The nginx config at `Vyba-dashboard-admin/nginx.conf` currently has zero security headers — no CSP, no HSTS, no frame protection.

**Rules**: Replace nginx.conf with hardened version:

```nginx
server {
    listen 80;
    server_name _;
    server_tokens off;

    # Redirect HTTP to HTTPS (uncomment when TLS is configured)
    # return 301 https://$host$request_uri;

    root /usr/share/nginx/html;
    index index.html;

    # --- Security Headers ---
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://api.vyba.app; frame-ancestors 'none'; base-uri 'self'; form-action 'self'" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
    add_header X-XSS-Protection "0" always;

    # --- Rate Limiting (define zone in http block) ---
    # limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;
    # limit_req zone=general burst=20 nodelay;

    # --- Static Assets (hashed filenames = immutable) ---
    location /assets {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # --- SPA Routing ---
    location / {
        try_files $uri $uri/ /index.html;
    }

    # --- Block sensitive paths ---
    location ~ /\. { deny all; }
    location = /robots.txt { allow all; }
    location = /.well-known/security.txt { allow all; }
}
```

**Mistakes to avoid**:
- Setting `X-XSS-Protection: 1; mode=block` (creates vulnerabilities in older browsers; CSP supersedes it)
- Allowing `frame-ancestors` for third-party embeds unless explicitly needed
- Forgetting `connect-src` for API domain in CSP (breaks all Axios calls)
- Not adding `always` to `add_header` (headers won't be sent on error responses)

---

### S8. Bot Protection

**Why**: OTP endpoints, booking flows, and auth forms are abuse targets for automated attacks and credential stuffing.

**Rules**:

- **Flutter**: Implement device attestation via Google Play Integrity API (Android) and Apple App Attest (iOS). Send attestation token with sensitive requests (login, OTP, booking).
- **React**: Integrate reCAPTCHA v3 (invisible) or hCaptcha on sign-in, sign-up, and forgot-password forms.
- **Both**: Implement client-side request fingerprinting (device ID, screen resolution, timezone) to aid server-side bot detection.
- **Server-side requirements** (document for backend team): Rate limit OTP requests to 3 per phone number per 10 minutes. Implement progressive delays after failed attempts.

**Mistakes to avoid**:
- Using reCAPTCHA v2 (poor UX) when v3 invisible is sufficient
- Not handling attestation/captcha failures gracefully (show error, don't crash)
- Blocking legitimate users with overly aggressive rate limits

---

### S9. Input Validation & Sanitization

**Why**: Both apps accept user input (reviews, venue names, search queries, profile data, bookings).

**Rules**:

- **Validate on client AND server** — client validation is UX, server validation is security.

- **Flutter** (`lib/core/utils/validators.dart`): Extend the existing `Validators` class. Add `maxLength`, URL validator, and phone normalization. Never pass raw user input to `Uri.parse()` or shell commands.

```dart
// Add to existing Validators class
static String? url(String? value) {
  if (value == null || value.trim().isEmpty) return null; // optional field
  final uri = Uri.tryParse(value.trim());
  if (uri == null || !['https'].contains(uri.scheme)) {
    return 'Please enter a valid HTTPS URL';
  }
  return null;
}

static String? maxLength(String? value, int max) {
  if (value != null && value.length > max) return 'Maximum $max characters';
  return null;
}
```

- **React**: Use Zod schemas for all forms (already in place). See S4 for password schema. Add URL and phone schemas:

```typescript
const urlSchema = z.string().url().startsWith('https://');
const phoneSchema = z.string().regex(/^\+[1-9]\d{6,14}$/, 'Must be E.164 format');
```

- **Sanitization**: Strip HTML tags from plain-text inputs. Normalize Unicode. Trim whitespace. For file uploads, sanitize filenames (remove path separators, limit length, allowlist extensions).

**Mistakes to avoid**:
- Using regex-only email validation — use Zod `.email()` or established RFC regex
- Not validating input length (DoS via oversized payloads)
- Trusting client-reported phone format without server-side normalization

---

### S10. Secrets Management

**Why**: API keys, signing keys, and tokens must never appear in source code or version control.

**Rules**:

- **Never commit**: `.env`, `key.properties`, `*.keystore`, `*.jks`, `*.p12`, `google-services.json`, `GoogleService-Info.plist`, service account JSON files. Verify these patterns exist in `.gitignore` for both projects.

- **Flutter**: Use `flutter_dotenv` for non-secret config. Use `--dart-define` or `--dart-define-from-file` for build-time secrets. Never hardcode API keys in Dart source.

- **React**: `VITE_` env vars are embedded in the JS bundle and visible to users. Only use for **public** config (API URL, app name). Backend API keys must never appear in frontend code.

- **CI/CD**: Use GitHub Actions secrets (`${{ secrets.KEY_NAME }}`). Never echo secrets in CI logs. Use `--frozen-lockfile` for reproducible builds.

- **Mock credentials** (P0): `Vyba-mobile-app/lib/features/auth/data/datasources/mock_auth_remote_datasource.dart` contains `test@gmail.com / passworD@123`. Gate behind `USE_MOCK_AUTH` + development-only assertion (see S4). Never ship with mock auth enabled.

**Mistakes to avoid**:
- Committing `.env` files (even "example" files with real values)
- Using the same API key for dev and production environments
- Hardcoding OTP bypass codes (e.g., `123456`) in non-mock code
- Prefixing secret keys with `VITE_` (exposes them in the client bundle)

---

### S11. Frontend Bundle Security

**Why**: JS bundles and Flutter APKs can be reverse-engineered to extract secrets, API logic, and debug routes.

**Rules**:

- **React/Vite**: Enable minification (Vite does this by default). Set `build.sourcemap: false` in `vite.config.ts` for production. Never include source maps in Docker image.

```typescript
// vite.config.ts — add to defineConfig
build: {
  sourcemap: false, // Never ship source maps
}
```

- **Flutter**: ProGuard/R8 already enabled. Add obfuscation to release builds:

```bash
# In Makefile — add target for secure release builds
release-apk:
	flutter build apk --release --obfuscate --split-debug-info=build/debug-info

release-ios:
	flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

- **Both**: Audit bundle for leaked secrets. Use `pnpm knip` (dashboard) to remove unused code. Never embed admin/debug routes in production builds.

- **React**: Use environment-conditional code elimination: `if (import.meta.env.DEV)` blocks are stripped by Vite in production.

**Mistakes to avoid**:
- Shipping source maps to production (enables full source code reconstruction)
- Including mock datasources in production Flutter builds
- Leaving debug `console.log` in production bundles
- Not running `--obfuscate` on release APK/IPA builds

---

### S12. Secure Logging

**Why**: The `LoggingInterceptor` at `lib/core/network/interceptors/logging_interceptor.dart` logs `options.data` (request bodies) which may include passwords, tokens, and PII.

**Rules**:

- **Flutter**: Create a `LogSanitizer` utility. Redact sensitive fields before logging. Only log in debug/development mode.

```dart
class LogSanitizer {
  static const _sensitiveKeys = {
    'password', 'token', 'access_token', 'refresh_token',
    'otp', 'code', 'authorization', 'secret', 'pin',
  };

  static dynamic sanitize(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) {
        if (_sensitiveKeys.contains(key.toLowerCase())) {
          return MapEntry(key, '***REDACTED***');
        }
        return MapEntry(key, sanitize(value));
      });
    }
    if (data is List) return data.map(sanitize).toList();
    return data;
  }
}
```

Update `LoggingInterceptor` to use `LogSanitizer.sanitize(options.data)` instead of raw `options.data`. Disable entirely in production via `ENABLE_LOGGING=false`.

- **React**: Remove all `console.log(data)` calls from auth forms. Remove `eslint-disable-next-line no-console` overrides. Use a proper structured logger if logging is needed.

- **Both**: Never log full request/response bodies in production. Log only: method, URL path, status code, response time. Redact PII from crash reports sent to Sentry/Crashlytics.

**Mistakes to avoid**:
- Logging full HTTP headers (includes `Authorization: Bearer ...`)
- Using `AppLogger.debug('Body: ${options.data}')` in production
- Sending PII in error breadcrumbs to crash reporting services
- Disabling ESLint `no-console` rule for convenience

---

### S13. Error Handling & Information Leakage

**Why**: Server error messages are currently passed through to UI in both apps, potentially revealing stack traces, SQL errors, or internal paths.

**Rules**:

- **Flutter**: In `ErrorInterceptor._handleBadResponse`, replace raw server messages for 5xx errors with generic text. Only show server messages for 4xx validation errors.

```dart
// In error_interceptor.dart — _handleBadResponse
String _getSafeMessage(int statusCode, Map<String, dynamic>? data) {
  if (statusCode >= 500) return 'Something went wrong. Please try again later.';
  // 4xx: show server validation message if available
  return (data?['message'] as String?) ?? 'An error occurred.';
}
```

- **React**: In `handleServerError`, sanitize messages for 5xx. Show generic message. Never display raw exception strings.

```typescript
// src/utils/handle-server-error.ts
function getSafeMessage(error: AxiosError): string {
  const status = error.response?.status ?? 500;
  if (status >= 500) return 'Something went wrong. Please try again later.';
  return (error.response?.data as any)?.title ?? 'An error occurred.';
}
```

- **Both**: Error states should show user-friendly messages with action buttons (retry, contact support). Never display: stack traces, SQL errors, internal file paths, server framework names, or raw exception class names.

**Mistakes to avoid**:
- Showing `UnauthorizedException(message: '...')` directly to user (leaks auth model)
- Including error details in production toast notifications
- Logging stack traces to user-visible crash dialogs

---

### S14. Dependency Security

**Why**: Third-party packages are the #1 supply chain attack vector. Neither project has automated dependency auditing.

**Rules**:

- **Flutter**: Run `dart pub outdated` monthly. Pin exact versions for security-critical packages. Audit new packages before adding: check pub.dev score, last update date, GitHub issues.

- **React**: Run `pnpm audit` in CI. Use `--frozen-lockfile` (already done). Run `pnpm knip` to detect unused deps.

- **CI**: Add audit steps that fail the build on high/critical vulnerabilities:

```yaml
# In dashboard CI workflow — add after lint step
- name: Security audit
  run: pnpm audit --audit-level=high

# In mobile CI workflow — add after analyze step
- name: Dependency check
  run: |
    cd Vyba-mobile-app
    dart pub outdated --no-dev-dependencies --up-to-date
```

- **Dependabot**: Configure automated dependency update PRs:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: /Vyba-dashboard-admin
    schedule: { interval: weekly }
    open-pull-requests-limit: 10
  - package-ecosystem: pub
    directory: /Vyba-mobile-app
    schedule: { interval: weekly }
    open-pull-requests-limit: 10
```

**Mistakes to avoid**:
- Using `^` version ranges for security-critical packages in pubspec.yaml
- Ignoring audit warnings in CI output
- Adding packages with < 100 pub.dev likes or no recent maintenance
- Auto-merging major version bumps without review

---

### S15. CI/CD Hardening

**Why**: Current CI only runs lint + type-check + build. No security scanning, no secret detection, no signed artifacts.

**Rules**:

- **Add to both CI workflows**:

```yaml
# Secret scanning — add as first job
- name: Secret scanning
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# SAST (dashboard) — add after lint
- name: SAST scan
  uses: github/codeql-action/analyze@v3
  with:
    languages: javascript-typescript
```

- **Branch protection**: Require PR reviews. Require CI pass before merge. No direct push to `main`. Enable signed commits.

- **Artifact signing (Flutter)**: Sign APK/IPA with release keys stored in CI secrets (`${{ secrets.KEYSTORE_BASE64 }}`), never in repo.

- **Build reproducibility**: Use locked dependency versions (`--frozen-lockfile`, `pubspec.lock`). Pin CI runner versions. Pin action versions to SHA, not tags.

**Mistakes to avoid**:
- Allowing CI to pass with audit warnings
- Storing signing keys in the repository (even encrypted)
- Running security checks only on `main`, not on PRs
- Using `@latest` or `@v2` for GitHub Actions (use SHA pins for supply chain safety)

---

### S16. Encryption (Transit & At Rest)

**Why**: User data, sync queue, and cached profiles are stored unencrypted on-device. Network traffic lacks certificate pinning.

**Rules**:

- **In transit**: HTTPS everywhere (see S6). Certificate pinning (see S6). TLS 1.2 minimum. No fallback to HTTP.

- **At rest (Flutter)**:
  - Tokens: already in `flutter_secure_storage` (platform-encrypted via Keystore/Keychain).
  - User profile: currently in `SharedPreferences` (plain text XML/plist). **Move to `SecureStorage`** or encrypt before caching.
  - Drift database: Encrypt with SQLCipher. Add `sqlcipher_flutter_libs` to `pubspec.yaml` and pass encryption key from secure storage.

```dart
// Encrypted Drift database setup
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vyba.db'));
    // Retrieve or generate key from SecureStorage
    final key = await secureStorage.getDatabaseKey();
    return NativeDatabase(file, setup: (db) {
      db.execute("PRAGMA key = '$key';");
    });
  });
}
```

  - Sync queue: stored in Drift — encrypting the DB covers this (F19).

- **At rest (React)**: Cookies use `Secure` flag (see S4). Minimize `localStorage` usage to non-sensitive data only (theme, sidebar state). Never store tokens or PII in `localStorage`.

- **Android**: Set `android:allowBackup="false"` in manifest to prevent unencrypted backup extraction.

```xml
<application
    android:allowBackup="false"
    android:usesCleartextTraffic="false"
    ...>
```

- **iOS**: Data Protection entitlement is default with `flutter_secure_storage`. Exclude cache files from iCloud backup.

**Mistakes to avoid**:
- Assuming `SharedPreferences` is secure (it's plain XML on Android, plist on iOS)
- Using the same encryption key for all users/devices (generate per-install)
- Not encrypting database backups
- Storing encryption keys alongside the encrypted database

---

### S17. Deployment Hardening

**Why**: Docker image and nginx config are minimal. The container runs as root with no additional protections.

**Rules**:

- **nginx**: Use hardened config from S7. Add `server_tokens off;` (already included). Add rate limiting zones in the `http` block.

- **Docker**: Run as non-root user. Drop capabilities. Use read-only filesystem where possible.

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

FROM nginx:alpine
# Remove default config
RUN rm /etc/nginx/conf.d/default.conf
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# Copy build output and config
COPY --from=build --chown=appuser:appgroup /app/dist /usr/share/nginx/html
COPY --chown=appuser:appgroup nginx.conf /etc/nginx/conf.d/default.conf
# Run as non-root (requires nginx config adjustments for pid/cache paths)
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

- **Android network security config**: Create `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    <!-- Pin API domain certificates -->
    <domain-config>
        <domain includeSubdomains="true">api.vyba.app</domain>
        <pin-set expiration="2027-01-01">
            <pin digest="SHA-256">BASE64_ENCODED_HASH_HERE</pin>
            <pin digest="SHA-256">BACKUP_PIN_HASH_HERE</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

Reference in `AndroidManifest.xml`:

```xml
<application android:networkSecurityConfig="@xml/network_security_config" ...>
```

- **security.txt**: Add `/.well-known/security.txt` to the dashboard's static assets:

```
Contact: security@vyba.app
Preferred-Languages: en
Canonical: https://vyba.app/.well-known/security.txt
Expires: 2027-01-01T00:00:00.000Z
```

- **robots.txt**: Disallow admin/API paths:

```
User-agent: *
Disallow: /api/
Disallow: /admin/
Allow: /
```

**Mistakes to avoid**:
- Running nginx as root in container
- Exposing Docker health check endpoints publicly
- Leaving `android:debuggable="true"` in release builds
- Not setting a backup pin for certificate pinning (risks lockout on cert rotation)

---

### S18. File Uploads & Webhooks

**Why**: Venue images, profile photos, and review attachments involve file uploads. Future webhook integrations need signature verification.

**Rules**:

- **File uploads (Flutter)**: Validate MIME type on client AND server. Limit file size (5MB for images). Allowlist extensions: `.jpg`, `.jpeg`, `.png`, `.webp`. Sanitize filenames. Never use user-provided filename as storage key.

```dart
bool isValidImageFile(File file) {
  final ext = p.extension(file.path).toLowerCase();
  const allowed = {'.jpg', '.jpeg', '.png', '.webp'};
  if (!allowed.contains(ext)) return false;
  if (file.lengthSync() > 5 * 1024 * 1024) return false; // 5MB
  return true;
}
```

- **File uploads (React)**: Same validations. Use `input[accept="image/jpeg,image/png,image/webp"]` for UX. Validate on submit.

- **Image processing**: Resize/compress before upload to prevent zip-bomb attacks. Strip EXIF metadata (may contain GPS coordinates — privacy risk).

- **Webhooks (if used)**: Verify webhook signatures using HMAC-SHA256. Validate source IP if provider publishes ranges. Implement idempotency keys to prevent replay attacks.

```typescript
// Webhook signature verification example
import { createHmac, timingSafeEqual } from 'crypto';

function verifyWebhookSignature(payload: string, signature: string, secret: string): boolean {
  const expected = createHmac('sha256', secret).update(payload).digest('hex');
  return timingSafeEqual(Buffer.from(signature), Buffer.from(expected));
}
```

**Mistakes to avoid**:
- Trusting `Content-Type` header from client (validate magic bytes server-side)
- Storing uploaded files in publicly accessible directories without authorization
- Not stripping EXIF data from user-uploaded images (GPS coordinate leak)
- Using `===` instead of `timingSafeEqual` for signature comparison (timing attack)

---

### S19. AI & Prompt Injection Prevention

**Why**: Forward-looking — if AI features are added (venue recommendations, chat, content generation), they must be hardened against prompt injection. No AI features exist in the repo yet.

**Rules**:

- Never pass raw user input as system prompts. Always sanitize and template:

```typescript
// SAFE — user input is data, not instruction
const prompt = `Summarize this review. The review text is:\n"""${sanitize(userReview)}"""`;

// UNSAFE — user input can manipulate system behavior
const prompt = `${userInput}`;
```

- Implement output filtering: check AI responses for PII, profanity, and injection markers before rendering.
- Rate limit AI endpoint calls. Set max token limits per request and per user per hour.
- Log AI interactions (without PII) for audit trail.
- Use a deny-list for known prompt injection patterns (`ignore previous instructions`, `system:`, etc.).

**Mistakes to avoid**:
- Using user-provided text as part of system instructions
- Displaying raw AI output without sanitization
- Not rate-limiting AI endpoints (cost explosion + abuse risk)
- Allowing AI to access internal APIs or databases without sandboxing

---

### S20. Abuse Prevention & Business Logic Security

**Why**: Nightlife platform has specific abuse vectors: fake reviews, booking spam, venue impersonation, OTP bombing, role escalation.

**Rules**:

- **OTP brute-force**: Max 3 OTP verification attempts per code. New code after 3 failures. 60-second cooldown between OTP requests. The mock uses `123456` — real implementation must generate random 6-digit codes server-side.

- **Review spam**: Rate limit reviews (1 per venue per user per 24h). Require a completed booking to leave a review. Flag reviews with duplicate content.

- **Booking abuse**: Limit pending bookings per user (e.g., max 5 active). Implement no-show tracking. Cancel unconfirmed bookings after timeout (e.g., 15 minutes).

- **Role escalation**: Never allow client-side role changes to propagate to server without re-authentication. The `RoleSelectionPage` must call a server endpoint that validates the role change. Never trust `UserRole` from local storage.

- **Favorites/feed**: Rate limit toggle operations (e.g., max 30 per minute). Enforce pagination limits server-side (max 50 items per page).

- **Root/jailbreak detection (Flutter)** (P2): Use `flutter_jailbreak_detection` or `freeRASP`. Warn user or restrict sensitive features (payments, token storage) on compromised devices.

```dart
// Root/jailbreak detection at app startup
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future<void> checkDeviceIntegrity() async {
  final isJailbroken = await FlutterJailbreakDetection.jailbroken;
  if (isJailbroken) {
    // Log event, restrict sensitive features, or show warning
    AppLogger.warning('Compromised device detected');
  }
}
```

**Mistakes to avoid**:
- Allowing unlimited OTP requests (SMS bombing attack — costs money, annoys users)
- Trusting client-reported `UserRole` for authorization decisions
- Not implementing booking expiration (ghost bookings block real users)
- Relying solely on client-side rate limiting (server must enforce)

---

### S21. Security Testing

**Why**: Security must be verified, not assumed. Neither project currently has security-focused tests or scanning.

**Rules**:

- **SAST**: Run CodeQL/semgrep in CI for React (see S15). Run `dart analyze` with `very_good_analysis` (already configured) for Flutter. Add `eslint-plugin-security` for React.

- **DAST**: Run OWASP ZAP against staging API and dashboard. Quarterly minimum.

- **Penetration testing**: Annual third-party pentest before major launches.

- **Unit tests for auth**: Test token refresh flow, expired token handling, unauthorized access, all validators with edge cases (empty, oversized, special characters, Unicode, null bytes).

```dart
// Example: validator edge case tests
test('password rejects common patterns', () {
  expect(Validators.password('12345678'), isNotNull); // no uppercase/special
  expect(Validators.password('Password1!'), isNull);  // valid
  expect(Validators.password(''), isNotNull);          // empty
  expect(Validators.password('a' * 129), isNotNull);   // too long
});
```

- **Integration tests**: Auth robot tests already exist in Flutter. Add: test logout clears all state, test expired token triggers refresh, test role-based routing redirects.

- **Dependency audit**: Monthly `pnpm audit` and `dart pub outdated`. Track CVEs for critical packages (Dio, Axios, GoRouter, TanStack Router).

**Mistakes to avoid**:
- Only testing happy paths in auth flows
- Not testing what happens when tokens expire mid-session
- Skipping security testing because "the backend handles it"
- Running DAST scans against production (use staging)

---

### Security Audit Checklist

> Point-in-time backlog captured when the framework was written. Some items are
> already done (see **Status notes** at the top). The `security-hardening-audit`
> skill produces the current status.

**P0 — Must fix before any deployment:**

- [x] Replace mock login in dashboard with real API authentication (F01)
- [ ] Add `beforeLoad` auth guard to `_authenticated` route layout (F02)
- [ ] Remove `console.log(data)` and `eslint-disable` overrides from auth forms (F03)
- [ ] Set cookie flags: `secure: true`, `sameSite: 'strict'` on auth token (F04)
- [ ] Gate mock datasource behind `USE_MOCK_AUTH` + dev-only assertion (F05)
- [ ] Add `android:usesCleartextTraffic="false"` to AndroidManifest (F11)

**P1 — Must fix before public launch:**

- [ ] Implement certificate pinning in Dio client (F06)
- [ ] Add JWT expiry validation in both auth interceptors (F07)
- [ ] Replace nginx.conf with hardened version from S7 (F08)
- [ ] Move cached user from SharedPreferences to SecureStorage (F09)
- [ ] Add `LogSanitizer` to redact sensitive fields in LoggingInterceptor (F10)
- [ ] Add runtime HTTPS assertion in AppConfig (F11)
- [ ] Update password schema to min 8 chars + complexity in React (F12)
- [ ] Add request timeout (30s) to Axios instance

**P2 — Fix in next sprint after launch:**

- [ ] Encrypt Drift database with SQLCipher (F13)
- [ ] Add root/jailbreak detection (F14)
- [ ] Add reCAPTCHA v3 to dashboard auth forms (F15/F16)
- [ ] Add CSRF protection via `X-Requested-With` header + `SameSite` cookies (F15)
- [ ] Add `pnpm audit --audit-level=high` to CI pipeline (F18)
- [ ] Add gitleaks secret scanning to CI (F18)
- [ ] Install and use DOMPurify for user-generated content in dashboard (F17)
- [ ] Add `build.sourcemap: false` to Vite production config
- [ ] Add `--obfuscate --split-debug-info` to Flutter release builds
- [ ] Set `android:allowBackup="false"` in AndroidManifest

**P3 — Ongoing hardening:**

- [ ] Configure Dependabot for both projects (F23)
- [ ] Add security.txt and robots.txt to dashboard (F22)
- [ ] Switch Docker base to distroless or slim nginx (F20)
- [ ] Sanitize error messages for 5xx responses in both apps (F21)
- [ ] Add `eslint-plugin-security` to dashboard ESLint config
- [ ] Quarterly OWASP ZAP scan against staging
- [ ] Annual third-party penetration test
- [ ] Strip EXIF metadata from user-uploaded images
- [ ] Implement device attestation (Play Integrity / App Attest)
- [ ] Add network security config XML with certificate pins for Android
