# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Production-ready Flutter Clean Architecture template using Riverpod, GoRouter, Dio, Freezed, and dartz. Environment configuration via `flutter_dotenv` (`.env` files).

## Common Commands

```bash
# Run the app
flutter run              # or: make run

# Code generation (freezed, json_serializable, riverpod_generator)
dart run build_runner build --delete-conflicting-outputs   # or: make gen

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs   # or: make watch

# Run all tests
flutter test             # or: make test

# Run integration tests
flutter test integration_test   # or: make integration

# Run a single test file
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Analyze code (uses very_good_analysis + custom_lint + riverpod_lint)
flutter analyze          # or: make analyze

# Format code
dart format .            # or: make format

# Generate localization files
flutter gen-l10n         # or: make l10n

# Generate app icons / splash screen
dart run flutter_launcher_icons    # or: make icons
dart run flutter_native_splash:create   # or: make splash
```

## Environment Configuration

Uses `flutter_dotenv` to load from a single `.env` file. Switch environments by copying:
```bash
cp .env.development .env   # Development (mock auth, logging on)
cp .env.staging .env       # Staging (real API, logging on)
cp .env.production .env    # Production (real API, logging off)
```

## Architecture

### Clean Architecture Layers (per feature in `lib/features/`)

Each feature follows `domain/ → data/ → presentation/`:

- **domain/**: Entities, abstract repository interfaces, use cases. Returns `Either<Failure, T>` (dartz). No framework dependencies.
- **data/**: Repository implementations, remote/local datasources, models (freezed + json_serializable). Models have `toEntity()` to convert to domain entities.
- **presentation/**: Pages, widgets, Riverpod providers/notifiers. State classes use freezed sealed unions.

### Core (`lib/core/`)

- **config/**: Abstract `Env` base class with `AppConfig` implementation reading from `.env` via flutter_dotenv. Injected via `envProvider` override at bootstrap.
- **network/**: `DioClient` factory with interceptor chain (LoggingInterceptor → AuthInterceptor → ErrorInterceptor). `ApiEndpoints` centralizes URL constants.
- **router/**: GoRouter with `StatefulShellRoute` for bottom navigation (home/profile/settings tabs). Global redirect handles auth state + onboarding guards. Auth state synced to GoRouter via `ValueNotifier` bridge from Riverpod. `AnalyticsObserver` for automatic screen tracking.
- **error/**: Exception hierarchy (`ServerException`, `CacheException`, `NetworkException`, `UnauthorizedException`) mapped to `Failure` types in repository layer.
- **services/**: Abstract interfaces for `CrashReporter` and `AnalyticsService` with dev implementations. Override providers with real implementations (e.g., Firebase, Sentry) for production.
- **widgets/**: Reusable UI components organized by category (buttons, inputs, feedback, layout, data_display, loading, states).
- **theme/**: Design tokens (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`) composed in `AppTheme`. Theme mode managed via `ThemeModeNotifier`.
- **providers/**: Core dependency providers (storage, network, connectivity, crash reporter, analytics).

### Data Flow

```
Page → Notifier → UseCase → Repository → DataSource (Dio/Storage)
                                ↓
                    Either<Failure, T> flows back up
                                ↓
                    Notifier updates state (freezed sealed class)
                                ↓
                    GoRouter redirects based on auth state
```

### Key Patterns

- **UseCase base class** (`core/usecase/usecase.dart`): `abstract class UseCase<T, Params>` with `Future<Either<Failure, T>> call(Params)`.
- **Riverpod providers** wire the DI graph: env → dio → datasources → repositories → usecases → notifiers. Core providers use `keepAlive: true`.
- **Bootstrap** (`bootstrap.dart`): Initializes bindings, pre-loads SharedPreferences, sets up crash reporting and error handling, wraps app in `ProviderScope` with env overrides.
- **Auth interceptor**: `QueuedInterceptor` handles 401 token refresh automatically.
- **Repository pattern**: Checks `NetworkInfo.isConnected` before remote calls, catches exceptions, caches on success, returns `Left(Failure)` or `Right(T)`.
- **Page transitions**: `AppPageTransitions` utility provides fade, slide, and scale transitions for GoRouter routes.

## Code Generation

Files matching `*.g.dart` and `*.freezed.dart` are generated. After changing any class annotated with `@freezed`, `@JsonSerializable`, or `@riverpod`/`@Riverpod`, run `dart run build_runner build --delete-conflicting-outputs`. These files are excluded from analysis in `analysis_options.yaml`.

## Localization

ARB files in `lib/l10n/` with template `app_en.arb`. Generated class is `AppLocalizations` (configured in `l10n.yaml`). `flutter: generate: true` is set in pubspec.yaml.

## Testing

Tests use `mocktail` for mocking. Test helpers and mock providers are in `test/helpers/`. Tests cover use cases, repositories, notifiers, and widget tests. Integration tests are in `integration_test/` using the robot pattern.

## Lint Rules

Uses `very_good_analysis` as base with `riverpod_lint` and `custom_lint` plugins. Disabled rules: `public_member_api_docs`, `lines_longer_than_80_chars`, `flutter_style_todos`, `one_member_abstracts`.

## Design System

Uses `flutter_screenutil` with a 375x812 design size. Responsive breakpoints handled by `ResponsiveBuilder` widget. All spacing, radius, shadow, and color values are centralized in `core/theme/`.
