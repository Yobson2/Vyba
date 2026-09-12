import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_broadcast_state.freezed.dart';

/// The owner broadcast action's state (ticket 17) — `alreadySentTonight` is
/// distinct from a generic `errorMessage` so the UI can show the "déjà
/// envoyé ce soir" state instead of a retry affordance.
@freezed
abstract class OwnerBroadcastState with _$OwnerBroadcastState {
  const factory OwnerBroadcastState({
    @Default(false) bool submitting,
    @Default(false) bool sent,
    @Default(false) bool alreadySentTonight,
    String? errorMessage,
  }) = _OwnerBroadcastState;
}
