/// Maps a backend typed auth error code to French copy for the OTP flow.
///
/// Falls back to a generic message for anything unmapped (network errors,
/// unexpected server errors) rather than surfacing a raw English message.
String otpErrorMessage(String? code) {
  return switch (code) {
    'AUTH_VERIFY_001' => 'Code incorrect. Réessayez.',
    'AUTH_VERIFY_002' => 'Ce code a expiré. Demandez-en un nouveau.',
    'AUTH_VERIFY_003' =>
      'Confirmez que vous avez 18 ans ou plus pour continuer.',
    'AUTH_RATE_002' => 'Trop de tentatives. Réessayez dans quelques minutes.',
    'AUTH_ACCOUNT_003' => 'Ce compte a été désactivé.',
    _ => 'Une erreur est survenue. Veuillez réessayer.',
  };
}
