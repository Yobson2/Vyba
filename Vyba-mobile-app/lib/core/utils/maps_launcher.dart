/// Builds a Google Maps search URI for a coordinate — "Ouvrir dans Google
/// Maps" affordance on venue detail (spec 11). Mirrors the
/// `buildWhatsAppSupportUri` pattern in settings_page.dart: a plain URI
/// builder the caller passes to `launchUrl`.
Uri buildGoogleMapsUri(double latitude, double longitude) {
  return Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
  );
}
