---
name: flutter-feature-scaffold
description: >-
  Scaffold a new Clean Architecture feature in Vyba-mobile-app (lib/features/<name>/)
  with the exact domain/data/presentation layering the codebase already uses:
  entity, abstract repository, use cases (Either<Failure,T>), remote + mock
  datasources, Freezed JSON model with toEntity(), repository impl with
  try/catch->Left/Right, Riverpod DI provider graph, notifier, and Freezed sealed
  state union. Use when asked to "add a feature", "create a new screen/module",
  "wire up <X> in the mobile app", or to add a use case / datasource method to an
  existing feature. Also covers running code generation and registering routes.
---

# Flutter feature scaffold (Vyba-mobile-app)

Package name is `flutter_templates` — all internal imports are
`package:flutter_templates/...`. Design size 375x812, dark-first. Respect
`docs/design-system.md` and `docs/security.md` (no 1px borders, no `#000000`,
min radius 8px, 4px spacing grid; never hardcode credentials, never log
tokens/passwords). See also `docs/mobile.md` for the full layer reference.

## When to use

- New feature under `lib/features/<name>/` → full scaffold (all sections below).
- New operation on an existing feature → add a use case + repo method +
  datasource method + provider, then regenerate.
- New list/detail screen backed by data → add notifier + state + page.

Do **not** use for pure UI tweaks, copy/l10n changes, or bug fixes.

## Layer layout (mirror an existing feature such as `venues` or `reviews`)

```
lib/features/<name>/
  domain/
    entities/<name>.dart                  # @immutable plain class + enums, computed getters
    repositories/<name>_repository.dart    # abstract, methods -> Future<Either<Failure, T>>
    usecases/<verb>_<name>_usecase.dart    # extends UseCase<T, Params> (or NoParams)
  data/
    datasources/<name>_remote_datasource.dart      # abstract
    datasources/mock_<name>_datasource.dart         # in-memory list + Future.delayed latency
    models/<name>_model.dart               # @freezed, @JsonKey(name:'snake_case'), fromJson, toEntity()
    repositories/<name>_repository_impl.dart # implements repo; try { } on ServerException catch { Left(ServerFailure(...)) }
  presentation/
    providers/<name>_providers.dart        # DI graph: datasource -> repository -> use cases
    providers/<name>_list_notifier.dart    # @riverpod class, build() kicks off load, refresh()
    providers/<name>_list_state.dart       # @freezed sealed: initial | loading | loaded | error
    pages/<name>_page.dart
    widgets/<name>_card.dart
```

Generated files (`*.g.dart`, `*.freezed.dart`) are created by `make gen` — do not
hand-write them, but do add the `part '...';` directives.

## Templates

### Entity — `domain/entities/<name>.dart`
```dart
import 'package:flutter/foundation.dart';

@immutable
class <Name> {
  const <Name>({required this.id, required this.title});

  final String id;
  final String title;
}
```

### Repository interface — `domain/repositories/<name>_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/<name>/domain/entities/<name>.dart';

abstract class <Name>Repository {
  Future<Either<Failure, List<<Name>>>> get<Name>s();
  Future<Either<Failure, <Name>>> get<Name>ById(String id);
}
```

### Use case — `domain/usecases/get_<name>s_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/<name>/domain/entities/<name>.dart';
import 'package:flutter_templates/features/<name>/domain/repositories/<name>_repository.dart';

class Get<Name>sUseCase extends UseCase<List<<Name>>, Get<Name>sParams> {
  Get<Name>sUseCase(this._repository);
  final <Name>Repository _repository;

  @override
  Future<Either<Failure, List<<Name>>>> call(Get<Name>sParams params) {
    return _repository.get<Name>s();
  }
}

class Get<Name>sParams {
  const Get<Name>sParams({this.page = 1, this.limit = 20});
  final int page;
  final int limit;
}
```
Use `NoParams` from `core/usecase/usecase.dart` when there are no parameters.

### Model — `data/models/<name>_model.dart`
```dart
import 'package:flutter_templates/features/<name>/domain/entities/<name>.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '<name>_model.freezed.dart';
part '<name>_model.g.dart';

@freezed
abstract class <Name>Model with _$<Name>Model {
  const <Name>Model._();

  const factory <Name>Model({
    required String id,
    required String title,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _<Name>Model;

  factory <Name>Model.fromJson(Map<String, dynamic> json) =>
      _$<Name>ModelFromJson(json);

  <Name> toEntity() => <Name>(id: id, title: title);
}
```

### Remote datasource (abstract) — `data/datasources/<name>_remote_datasource.dart`
```dart
import 'package:flutter_templates/features/<name>/data/models/<name>_model.dart';

abstract class <Name>RemoteDataSource {
  Future<List<<Name>Model>> get<Name>s({int page = 1, int limit = 20});
  Future<<Name>Model> get<Name>ById(String id);
}
```

### Mock datasource — `data/datasources/mock_<name>_datasource.dart`
In-memory `List`, each method `await Future<void>.delayed(const Duration(milliseconds: 300))`
then returns/mutates the list. Mirror `mock_review_datasource.dart`.

### Repository impl — `data/repositories/<name>_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/<name>/data/datasources/<name>_remote_datasource.dart';
import 'package:flutter_templates/features/<name>/domain/entities/<name>.dart';
import 'package:flutter_templates/features/<name>/domain/repositories/<name>_repository.dart';

class <Name>RepositoryImpl implements <Name>Repository {
  <Name>RepositoryImpl(this._remoteDataSource);
  final <Name>RemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<<Name>>>> get<Name>s() async {
    try {
      final models = await _remoteDataSource.get<Name>s();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  // ...one method per repo contract entry, same shape
}
```

### Providers (DI graph) — `presentation/providers/<name>_providers.dart`
```dart
import 'package:flutter_templates/features/<name>/data/datasources/<name>_remote_datasource.dart';
import 'package:flutter_templates/features/<name>/data/datasources/mock_<name>_datasource.dart';
import 'package:flutter_templates/features/<name>/data/repositories/<name>_repository_impl.dart';
import 'package:flutter_templates/features/<name>/domain/repositories/<name>_repository.dart';
import 'package:flutter_templates/features/<name>/domain/usecases/get_<name>s_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<name>_providers.g.dart';

@Riverpod(keepAlive: true)
<Name>RemoteDataSource <name>RemoteDataSource(Ref ref) => Mock<Name>DataSource();

@Riverpod(keepAlive: true)
<Name>Repository <name>Repository(Ref ref) =>
    <Name>RepositoryImpl(ref.read(<name>RemoteDataSourceProvider));

@riverpod
Get<Name>sUseCase get<Name>sUseCase(Ref ref) =>
    Get<Name>sUseCase(ref.read(<name>RepositoryProvider));
```
Rules: datasources + repositories are `@Riverpod(keepAlive: true)`; use cases are
plain `@riverpod`. If the feature hits the real API, branch on
`dotenv.get('USE_MOCK_AUTH', fallback: 'false')` like `auth_providers.dart` and
inject `ref.watch(dioProvider)` from `core/providers/network_providers.dart`.

### State — `presentation/providers/<name>_list_state.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_templates/features/<name>/domain/entities/<name>.dart';

part '<name>_list_state.freezed.dart';

@freezed
sealed class <Name>ListState with _$<Name>ListState {
  const factory <Name>ListState.initial() = <Name>ListInitial;
  const factory <Name>ListState.loading() = <Name>ListLoading;
  const factory <Name>ListState.loaded({
    required List<<Name>> items,
    @Default(false) bool hasMore,
  }) = <Name>ListLoaded;
  const factory <Name>ListState.error({required String message}) = <Name>ListError;
}
```

### Notifier — `presentation/providers/<name>_list_notifier.dart`
```dart
import 'package:flutter_templates/features/<name>/domain/usecases/get_<name>s_usecase.dart';
import 'package:flutter_templates/features/<name>/presentation/providers/<name>_list_state.dart';
import 'package:flutter_templates/features/<name>/presentation/providers/<name>_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<name>_list_notifier.g.dart';

@riverpod
class <Name>ListNotifier extends _$<Name>ListNotifier {
  @override
  <Name>ListState build() {
    _load();
    return const <Name>ListState.loading();
  }

  Future<void> _load() async {
    final result =
        await ref.read(get<Name>sUseCaseProvider)(const Get<Name>sParams());
    result.fold(
      (failure) => state = <Name>ListState.error(message: failure.message),
      (items) => state = <Name>ListState.loaded(items: items),
    );
  }

  Future<void> refresh() async {
    state = const <Name>ListState.loading();
    await _load();
  }
}
```
For action/mutation flows (submit, toggle, delete) mirror `auth_notifier.dart`:
`state = ...loading()`, `try`, `result.fold(error, success)`, `catch` -> error.

## Failure types (`core/error/failures.dart`)

`ServerFailure`, `CacheFailure`, `NetworkFailure`, `UnauthorizedFailure`,
`SyncFailure(isPending)`, `ValidationFailure(errors)`. Data layer throws
`ServerException` / `CacheException` / `NetworkException` / `UnauthorizedException`
(`core/error/exceptions.dart`); repositories map them to failures.

## Routes

Add route path + name constants to `lib/core/router/route_names.dart`, then a
`GoRoute` in `lib/core/router/app_router.dart` under the right shell branch
(client: Explore/Feed/Bookings/Profile — owner: Dashboard/Bookings/Promos/Profile)
or as a child route. Public (no-auth) paths must be added to `_publicPaths`.

## Finish

1. `make gen` (required after any `@freezed` / `@JsonSerializable` / `@riverpod`).
2. `make analyze` — must pass (`very_good_analysis` + `riverpod_lint` + `custom_lint`).
3. `make format`.
4. If strings were added: update `lib/l10n/app_en.arb` **and** `app_fr.arb`, run `make l10n`.
5. Add at least a use-case unit test under `test/features/<name>/...` mirroring existing tests.
