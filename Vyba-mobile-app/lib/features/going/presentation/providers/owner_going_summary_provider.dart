import 'package:flutter_templates/features/going/presentation/providers/going_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_going_summary_provider.g.dart';

/// Rough party sizes for the owner home (ticket 08) — the going count itself
/// already rides along on `VenueNightNotifier`'s state; this adds just the
/// party-size texture.
@riverpod
Future<List<int>> ownerGoingSummary(
  OwnerGoingSummaryRef ref,
  String venueId,
) async {
  final result =
      await ref.read(getOwnerGoingSummaryUseCaseProvider).call(venueId);
  return result.fold((failure) => throw Exception(failure.message),
      (summary) => summary.partySizes);
}
