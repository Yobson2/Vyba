import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_providers.g.dart';

/// Provides [SharedPreferences] instance.
///
/// Must be overridden in [ProviderScope] at bootstrap with
/// the pre-initialized instance.

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferences must be overridden at bootstrap',
  );
}

/// Provides [LocalStorage] wrapper around [SharedPreferences].
@Riverpod(keepAlive: true)
LocalStorage localStorage(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorage(prefs);
}

/// Provides [SecureStorage] wrapper around [FlutterSecureStorage].
@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return const SecureStorage(storage);
}
