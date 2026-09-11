import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'going_state.freezed.dart';

/// "J'y vais" state for one venue tonight.
@freezed
sealed class GoingState with _$GoingState {
  const factory GoingState.loading() = GoingLoading;
  const factory GoingState.notMarked() = GoingNotMarked;
  const factory GoingState.marked(Going going) = GoingMarked;

  /// The signed-in user owns this venue — the backend refuses the mark.
  const factory GoingState.ownedVenue() = GoingOwnedVenue;

  /// Tapped while offline — fails immediately, no call, no queue (ADR-0002).
  const factory GoingState.offline() = GoingOffline;

  const factory GoingState.error(String message) = GoingErrorState;
}
