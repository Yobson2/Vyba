import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/availability_provider.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_notifier.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_state.dart';

/// Reservation request button + state, shown on the venue detail page only
/// when the venue opted in (ADR-0006) — most venues never render this.
class ReservationSection extends ConsumerWidget {
  const ReservationSection({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationNotifierProvider(venueId));
    final notifier = ref.read(reservationNotifierProvider(venueId).notifier);
    final availability = ref.watch(availabilityProvider(venueId));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_seat_outlined,
                  size: 18, color: AppColors.onSurfaceVariant),
              AppSpacing.horizontalSm,
              const Text(
                'Réservation',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              availability.when(
                data: (a) => Text(
                  a.confirmedReservationsCount != null
                      ? '${a.confirmedReservationsCount} confirmées ce soir'
                      : '',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          AppSpacing.verticalSm,
          switch (state) {
            ReservationLoading() => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ReservationOwnedVenue() => const Text(
                "C'est ton établissement — tu ne peux pas réserver ici.",
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ReservationOffline() => _RetryRow(
                icon: Icons.wifi_off_outlined,
                message: 'Connexion requise pour réserver.',
                onRetry: () => notifier.create(),
              ),
            ReservationErrorState(:final message) => _RetryRow(
                icon: Icons.error_outline,
                message: message,
                onRetry: () => notifier.create(),
              ),
            ReservationNotRequested() => SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => notifier.create(),
                  icon: const Icon(Icons.event_seat_outlined),
                  label: const Text('Réserver une table'),
                ),
              ),
            ReservationPending(:final reservation) => _RequestedControls(
                reservation: reservation,
                notifier: notifier,
                confirmed: false,
              ),
            ReservationConfirmed(:final reservation) => _RequestedControls(
                reservation: reservation,
                notifier: notifier,
                confirmed: true,
              ),
          },
        ],
      ),
    );
  }
}

class _RetryRow extends StatelessWidget {
  const _RetryRow({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        AppSpacing.horizontalSm,
        Expanded(
          child: Text(message,
              style: const TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        TextButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}

class _RequestedControls extends StatelessWidget {
  const _RequestedControls({
    required this.reservation,
    required this.notifier,
    required this.confirmed,
  });

  final Reservation reservation;
  final ReservationNotifier notifier;
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              confirmed ? Icons.check_circle : Icons.hourglass_top,
              color: confirmed ? AppColors.success : AppColors.onSurfaceVariant,
              size: 20,
            ),
            AppSpacing.horizontalSm,
            Text(
              confirmed ? 'Confirmée ✓' : 'En attente de confirmation',
              style: TextStyle(
                color:
                    confirmed ? AppColors.success : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: notifier.cancel,
              child: const Text('Annuler'),
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            const Text('Personnes : '),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: reservation.partySize > 1
                  ? () => notifier.create(partySize: reservation.partySize - 1)
                  : null,
            ),
            Text(
              '${reservation.partySize}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: reservation.partySize < 20
                  ? () => notifier.create(partySize: reservation.partySize + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
