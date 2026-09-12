import { FeedItem, FeedItemType } from './entities/feed-item.entity';

export enum FeedTier {
  TONIGHT = 0,
  THIS_WEEKEND = 1,
  UPCOMING = 2,
  RECENT = 3,
  EVERGREEN = 4,
}

const RECENT_WINDOW_MS = 48 * 60 * 60 * 1000;

/** Monday 00:00 UTC of the week containing `dateISO` ('YYYY-MM-DD'). */
function mondayOfWeek(dateISO: string): Date {
  const d = new Date(`${dateISO}T00:00:00Z`);
  const day = d.getUTCDay(); // 0=Sun..6=Sat
  const diffToMonday = (day + 6) % 7; // Mon->0, Sun->6
  d.setUTCDate(d.getUTCDate() - diffToMonday);
  return d;
}

/** Thu-Sun (inclusive) of the week containing `todayISO`. */
function isThisWeekend(relevantDateISO: string, todayISO: string): boolean {
  const monday = mondayOfWeek(todayISO);
  const thursday = new Date(monday);
  thursday.setUTCDate(monday.getUTCDate() + 3);
  const sunday = new Date(monday);
  sunday.setUTCDate(monday.getUTCDate() + 6);

  const relevant = new Date(`${relevantDateISO}T00:00:00Z`);
  return relevant >= thursday && relevant <= sunday;
}

function isoDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}

/**
 * Tier per spec 03: tonight > this weekend > upcoming > recent > evergreen.
 * `todayISO` is the Abidjan-local calendar date (`abidjanToday()`); `nowMs`
 * drives the "recent" (published < 48h ago) fallback for items with no
 * future relevance.
 */
export function computeTier(
  item: FeedItem,
  todayISO: string,
  nowMs: number,
): FeedTier {
  const relevantDateISO =
    item.type === FeedItemType.LIVE_TONIGHT ||
    item.type === FeedItemType.GOING_MILESTONE
      ? todayISO
      : item.startsAt
        ? isoDate(item.startsAt)
        : null;

  if (relevantDateISO === todayISO) {
    return FeedTier.TONIGHT;
  }

  if (relevantDateISO && relevantDateISO > todayISO) {
    return isThisWeekend(relevantDateISO, todayISO)
      ? FeedTier.THIS_WEEKEND
      : FeedTier.UPCOMING;
  }

  const publishedMs = item.publishedAt.getTime();
  return nowMs - publishedMs <= RECENT_WINDOW_MS
    ? FeedTier.RECENT
    : FeedTier.EVERGREEN;
}

/**
 * Bounded follow-lift (ticket 10, spec 03 §"Score"): a followed venue's
 * item sorts as if published this much more recently — enough to beat an
 * "equivalent" (similarly-timed) non-followed item within the same tier,
 * never enough to let a stale followed item beat a genuinely more recent
 * non-followed one, and it never crosses a tier boundary (tier compares
 * first). No going-count boost here — no ticket in the validation-MVP
 * breakdown claims it (ticket 07 stubbed it "for ticket 08", ticket 08's
 * own checklist never picked it up); left for a future ticket.
 */
const FOLLOW_LIFT_MS = 3 * 60 * 60 * 1000;

/**
 * Ranks candidates: tier ascending, then most-recently-published first
 * within a tier (with the bounded follow-lift folded into the effective
 * publish time). `isFollowedVenue` is omitted (or always-false) for an
 * unauthenticated read — no follow concept without a signed-in user.
 */
export function rankFeedItems(
  items: FeedItem[],
  todayISO: string,
  nowMs: number,
  isFollowedVenue: (venueId: string | null) => boolean = () => false,
): FeedItem[] {
  return [...items]
    .map((item) => ({
      item,
      tier: computeTier(item, todayISO, nowMs),
      effectiveMs:
        item.publishedAt.getTime() +
        (isFollowedVenue(item.venueId) ? FOLLOW_LIFT_MS : 0),
    }))
    .sort((a, b) => {
      if (a.tier !== b.tier) return a.tier - b.tier;
      return b.effectiveMs - a.effectiveMs;
    })
    .map(({ item }) => item);
}
