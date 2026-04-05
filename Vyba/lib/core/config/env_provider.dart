import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/config/app_config.dart';
import 'package:flutter_templates/core/config/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_provider.g.dart';

/// Provides the current [Env] configuration.
///
/// Override this provider in `ProviderScope.overrides` at bootstrap
/// to inject the correct environment per build flavor.
@Riverpod(keepAlive: true)
Env env(Ref ref) {
  return const AppConfig();
}
