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
 * Ranks candidates: tier ascending, then most-recently-published first
 * within a tier. No boost/follow-lift in this unit (ticket 07 scope —
 * see spec 03's "Out of Scope" for boosts/precomputation; the going-count
 * boost lands with ticket 08).
 */
export function rankFeedItems(
  items: FeedItem[],
  todayISO: string,
  nowMs: number,
): FeedItem[] {
  return [...items]
    .map((item) => ({ item, tier: computeTier(item, todayISO, nowMs) }))
    .sort((a, b) => {
      if (a.tier !== b.tier) return a.tier - b.tier;
      return b.item.publishedAt.getTime() - a.item.publishedAt.getTime();
    })
    .map(({ item }) => item);
}
