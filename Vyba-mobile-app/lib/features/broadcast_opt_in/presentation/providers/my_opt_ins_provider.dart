import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_opt_ins_provider.g.dart';

/// "Mes lieux avec notifications" (ticket 17).
@riverpod
class MyOptIns extends _$MyOptIns {
  @override
  Future<List<OptedInVenue>> build() async {
    final result =
        await ref.read(getMyOptInsUseCaseProvider).call(const NoParams());
    return result.fold((failure) => throw Exception(failure.message), (v) => v);
  }

  /// Called after an inline opt-out from the list itself, so the removed
  /// venue disappears without waiting for a manual pull-to-refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
