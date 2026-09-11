/// Maps a "J'y vais" error message/state to French copy.
String goingErrorMessage(String? code) {
  return switch (code) {
    'GOING_003' => 'Trop de tentatives. Réessaie plus tard.',
    'GOING_004' => "Trop tard — c'est verrouillé après minuit.",
    'GOING_001' => 'Aucune marque à modifier.',
    _ => 'Une erreur est survenue. Réessaie.',
  };
}
