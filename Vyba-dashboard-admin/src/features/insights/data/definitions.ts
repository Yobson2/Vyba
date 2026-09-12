/**
 * The §23.2 metric definitions, locked — this screen renders them, it
 * doesn't reinterpret them (spec 18). Mirrors the wording backing
 * `Vyba-backend`'s `MetricsService` and `UsersService` queries; kept in
 * sync by convention (no shared package across the two projects), the same
 * way each backend module redefines its own `ZONE_4` constant rather than
 * importing one from elsewhere.
 */
export const DEFINITIONS = {
  zone4Wau:
    'Utilisateurs actifs sur 7 jours glissants : activeZone = zone_4 et au moins une action significative (vue de lieu, "J\'y vais", suivi d\'un lieu, ...).',
  retention:
    'Part d\'une cohorte d\'inscription encore active (dernière action significative) au moins N semaines après son inscription.',
  organicPosting:
    'Lieux ayant publié au moins une promo en origin = venue (organique, non assistée par l\'équipe) cette semaine.',
  goingPerNight:
    'Somme du compteur "J\'y vais" par nuit (date du VenueNight), sur les ~8 dernières semaines.',
  quiet:
    'Un lieu est "silencieux" ce soir si : pas live, aucune publication aujourd\'hui, et moins de 3 "J\'y vais".',
} as const

export const GATE_TARGETS = {
  zone4Wau: '~500',
  weekFourRetention: '≥ 25%',
  organicPosting: '≥ 15 / ~30',
} as const

export const POSTHOG_LINKS = [
  { label: 'Zone 4 WAU cohort', url: 'https://app.posthog.com' },
  { label: 'Retention funnel', url: 'https://app.posthog.com' },
  { label: 'Posting funnel (organic vs assisted)', url: 'https://app.posthog.com' },
  { label: "Going / J'y vais funnel", url: 'https://app.posthog.com' },
] as const
