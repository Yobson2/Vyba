# Mobile app — `Vyba-mobile-app/`

Flutter client + venue-owner app. Bootstrapped from a Flutter Clean Architecture
template — the Dart package is still named **`flutter_templates`**, so all
internal imports are `package:flutter_templates/...`.

For the template's own overview (stack versions, feature list), see
[`Vyba-mobile-app/README.md`](../Vyba-mobile-app/README.md).

## Commands

```bash
make get           # flutter pub get
make gen           # build_runner build --delete-conflicting-outputs
make watch         # build_runner watch
make run           # flutter run
make test          # flutter test
make analyze       # flutter analyze (very_good_analysis + riverpod_lint + custom_lint)
make format        # dart format .
make l10n          # flutter gen-l10n
make clean         # clean + pub get
make icons         # flutter_launcher_icons
make splash        # flutter_native_splash

# One test file
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

After changing any `@freezed`, `@JsonSerializable`, or `@riverpod`/`@Riverpod`
class, run `make gen`. Generated files (`*.g.dart`, `*.freezed.dart`) are
excluded from analysis — never hand-edit them, but do add the `part` directives.

## Environment

`flutter_dotenv`. Copy `.env.example` → `.env`. Key vars: `ENV_NAME`,
`BASE_URL`, `ENABLE_LOGGING`, `SHOW_DEBUG_BANNER`, `USE_MOCK_AUTH`.

## Architecture — Clean Architecture per feature

Each feature lives under `lib/features/<name>/` with three layers:

- **`domain/`** — entities (plain `@immutable` classes), abstract repository
  interfaces, use cases extending `UseCase<T, Params>` and returning
  `Either<Failure, T>` (dartz).
- **`data/`** — repository implementations, remote/local datasources (abstract +
  a `mock_*` in-memory implementation), Freezed models with `@JsonKey`
  snake_case mapping and a `toEntity()` method.
- **`presentation/`** — pages, widgets, Riverpod notifiers, Freezed sealed-union
  state classes.

**Data flow**: Page → Notifier → UseCase → Repository → DataSource, results
returned as `Either<Failure, T>`.

Shared building blocks live in `lib/core/` (`theme/`, `network/`, `router/`,
`error/`, `usecase/`, `providers/`, `storage/`, `widgets/`, `database/`, `sync/`).

To scaffold a new feature, use the **`flutter-feature-scaffold`** skill.

## DI & state management (Riverpod)

Providers wire the graph `env → dio → datasources → repositories → usecases →
notifiers`.

- Core providers are `@Riverpod(keepAlive: true)`: env, storage, network,
  connectivity, analytics, crash reporter. Datasources and repositories are also
  `keepAlive`; use cases are plain `@riverpod`.
- `sharedPreferencesProvider` is overridden at bootstrap with a pre-initialized
  instance.
- Mock datasources are selected inside the provider by reading
  `USE_MOCK_AUTH` from `.env` (see `auth_providers.dart` for the pattern).
- State classes are Freezed sealed unions, e.g.
  `AuthState.initial | .loading | .authenticated(User) | .unauthenticated | .error(String)`.

## Routing (GoRouter)

- `StatefulShellRoute.indexedStack` for the two tab shells:
  - **Client**: Explore, Feed, Bookings, Profile
  - **Owner**: Dashboard, Bookings, Promos, Profile
- Auth state is bridged from Riverpod to GoRouter via a `ValueNotifier`
  (`refreshListenable`); a global `redirect` routes by `UserRole` after login and
  sends unauthenticated users on protected routes to login.
- Route paths and names are constants in `RouteNames`. Public (no-auth) paths are
  listed in `_publicPaths` in `app_router.dart`.

## Network

- `DioClient.create(env, secureStorage)` builds the Dio instance with the
  interceptor chain **Logging → Auth → Error**.
- `AuthInterceptor` is a `QueuedInterceptor`: on 401 it refreshes the token
  atomically and retries, queuing concurrent requests. Public paths skip the auth
  header (matched by exact path equality).
- Data layer throws `ServerException` / `CacheException` / `NetworkException` /
  `UnauthorizedException` (`core/error/exceptions.dart`); repositories catch
  these and return `Left(Failure)` — `ServerFailure`, `CacheFailure`,
  `NetworkFailure`, `UnauthorizedFailure`, `SyncFailure(isPending)`,
  `ValidationFailure(errors)` (`core/error/failures.dart`).

## Localization

Strings are bilingual: every key must exist in both `lib/l10n/app_en.arb` **and**
`lib/l10n/app_fr.arb`. Run `make l10n` after edits.

## Design tokens

`lib/core/theme/`: `app_colors.dart`, `app_spacing.dart`, `app_radius.dart`,
`app_shadows.dart`, `app_typography.dart`, `app_gradients.dart`, `app_effects.dart`,
`app_motion.dart`, `app_haptics.dart`. `ScreenUtilInit` uses a 375×812 design
size; `ResponsiveBuilder` handles breakpoints. See [`design-system.md`](design-system.md).

## Lint

Base `very_good_analysis` + `custom_lint` + `riverpod_lint`. Disabled:
`public_member_api_docs`, `lines_longer_than_80_chars`, `flutter_style_todos`,
`one_member_abstracts`. `make analyze` must pass clean.

## Offline sync

The `notes` feature and `lib/core/sync/` implement an offline-first queue with
Drift. Full design: [`Vyba-mobile-app/docs/offline_sync.md`](../Vyba-mobile-app/docs/offline_sync.md).
