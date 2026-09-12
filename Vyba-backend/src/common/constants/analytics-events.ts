/**
 * The core event taxonomy (spec 07) — initial but schema-stable. `venue_unfollowed`
 * is a ticket-10 addition alongside the spec's `venue_followed` (the spec's own
 * list only shows the follow side, but ticket 10 explicitly requires both).
 */
export const ANALYTICS_EVENTS = [
  'feed_opened',
  'feed_item_viewed',
  'venue_viewed',
  'venue_followed',
  'venue_unfollowed',
  'going_marked',
  'going_cancelled',
  'promo_viewed',
  'promo_created',
  'event_viewed',
  'post_created',
  'post_created_organically',
  'post_created_founder_assisted',
  'qr_landing_opened',
  'app_install_started',
] as const;

export type AnalyticsEvent = (typeof ANALYTICS_EVENTS)[number];

const ANALYTICS_EVENT_SET: ReadonlySet<string> = new Set(ANALYTICS_EVENTS);

export function isKnownAnalyticsEvent(event: string): event is AnalyticsEvent {
  return ANALYTICS_EVENT_SET.has(event);
}

/**
 * "Meaningful action" (spec 07, locked definition) — the one list both the
 * analytics proxy (for `activeZone` derivation) and the first-party WAU
 * query must use, so they never disagree.
 */
export const MEANINGFUL_ACTION_EVENTS: ReadonlySet<AnalyticsEvent> = new Set([
  'feed_item_viewed',
  'venue_viewed',
  'going_marked',
  'venue_followed',
]);

export function isMeaningfulAction(event: string): boolean {
  return MEANINGFUL_ACTION_EVENTS.has(event as AnalyticsEvent);
}
