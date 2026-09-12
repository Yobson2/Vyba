import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/services/attribution_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attribution_provider.g.dart';

@Riverpod(keepAlive: true)
AttributionService attributionService(Ref ref) {
  final localStorage = ref.watch(localStorageProvider);
  return AttributionService(
    ref.watch(dioProvider),
    localStorage.getOrCreateClientId,
  );
}
