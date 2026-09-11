import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_promo_state.freezed.dart';

/// The create-promo form's submission state, plus the last successfully
/// published promo (ticket 09: "publish → returns to home with the item
/// listed under recent activity" — the owner home reads [lastPublished] off
/// this notifier rather than a separate backend "my recent posts" read,
/// which is out of this ticket's backend scope).
@freezed
abstract class CreatePromoState with _$CreatePromoState {
  const factory CreatePromoState({
    @Default(false) bool submitting,
    String? errorMessage,
    Promo? lastPublished,
  }) = _CreatePromoState;
}
