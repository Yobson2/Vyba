import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/config/env_provider.dart';
import 'package:flutter_templates/core/network/dio_client.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_providers.g.dart';

/// Provides the [Connectivity] instance.
@Riverpod(keepAlive: true)
Connectivity connectivity(Ref ref) {
  return Connectivity();
}

/// Provides [NetworkInfo] for checking connectivity.
@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
}

/// Provides the configured [Dio] HTTP client.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final env = ref.watch(envProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient.create(env: env, secureStorage: secureStorage);
}
