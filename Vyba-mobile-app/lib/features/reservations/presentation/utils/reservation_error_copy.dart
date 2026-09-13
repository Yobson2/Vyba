/// Maps a reservation error code to French copy.
String reservationErrorMessage(String? code) {
  return switch (code) {
    'RESERVATION_003' => 'Trop de tentatives. Réessaie plus tard.',
    'RESERVATION_004' => "Trop tard — c'est verrouillé après minuit.",
    'RESERVATION_001' => 'Aucune demande à modifier.',
    'RESERVATION_005' => 'Ce lieu ne prend pas de réservations.',
    'RESERVATION_006' => 'Complet pour ce soir — plus de place disponible.',
    _ => 'Une erreur est survenue. Réessaie.',
  };
}
