/** Mirrors `Vyba-mobile-app`'s `buildGoogleMapsUri` — "Ouvrir dans Google Maps" (spec 14). */
export function googleMapsUrl(latitude: number, longitude: number): string {
  return `https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}`;
}
