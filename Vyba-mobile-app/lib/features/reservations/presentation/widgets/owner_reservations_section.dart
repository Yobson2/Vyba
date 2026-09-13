import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/owner_reservations_notifier.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/owner_reservations_state.dart';

/// Tonight's reservation requests for the owner's own venue — shown only
/// when the venue opted in (ADR-0006).
class OwnerReservationsSection extends ConsumerWidget {
  const OwnerReservationsSection({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ownerReservationsNotifierProvider(venueId));
    final notifier =
        ref.read(ownerReservationsNotifierProvider(venueId).notifier);

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
                'Réservations ce soir',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: notifier.refresh,
              ),
            ],
          ),
          switch (state) {
            OwnerReservationsLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            OwnerReservationsError(:final message) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(message, style: TextStyle(color: AppColors.error)),
              ),
            OwnerReservationsLoaded(:final requests) => requests.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'Aucune demande pour le moment.',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  )
                : Column(
                    children: requests
                        .map(
                          (r) => _RequestRow(
                            reservation: r,
                            onRespond: (confirm) =>
                                notifier.respond(r.id, confirm: confirm),
                          ),
                        )
                        .toList(),
                  ),
          },
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  const _RequestRow({required this.reservation, required this.onRespond});

  final Reservation reservation;
  final ValueChanged<bool> onRespond;

  @override
  Widget build(BuildContext context) {
    final isPending = reservation.status == ReservationStatus.pending;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reservation.partySize} personne(s)',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (reservation.note != null && reservation.note!.isNotEmpty)
                  Text(
                    reservation.note!,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (isPending) ...[
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.error, size: 20),
              onPressed: () => onRespond(false),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: AppColors.success, size: 20),
              onPressed: () => onRespond(true),
            ),
          ] else
            _StatusBadge(status: reservation.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ReservationStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReservationStatus.confirmed => ('Confirmée', AppColors.success),
      ReservationStatus.rejected => ('Refusée', AppColors.error),
      ReservationStatus.canceled => ('Annulée', AppColors.onSurfaceVariant),
      ReservationStatus.pending => ('En attente', AppColors.onSurfaceVariant),
    };
    return Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
    );
  }
}
