import { CalendarDays, Sparkles, Tag, Users } from "lucide-react";
import { useTranslations } from "next-intl";
import { cn } from "@/app/lib/utils";
import type { SampleVenue } from "./sample-venues";

/* ── Atoms — scaled-down equivalents of the app's widgets ─────────────── */

export function VenueAvatar({ venue, size = "md" }: { venue: SampleVenue; size?: "md" | "lg" }) {
  return (
    <span
      className={cn(
        "bg-surface-highest font-display text-primary flex shrink-0 items-center justify-center rounded-sm font-bold",
        size === "md" ? "size-8 text-[11px]" : "size-12 rounded-md text-base"
      )}
    >
      {venue.initials}
    </span>
  );
}

/** Emerald is reserved for live / availability (design-system.md). */
export function LiveBadge({ label, className }: { label: string; className?: string }) {
  return (
    <span
      className={cn(
        "bg-secondary/12 text-secondary inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 text-[10px] font-semibold",
        className
      )}
    >
      <span className="relative flex size-1.5">
        <span className="animate-live-ping bg-secondary absolute inset-0 rounded-full" />
        <span className="bg-secondary relative size-1.5 rounded-full" />
      </span>
      {label}
    </span>
  );
}

/** Golden Hour is reserved for promos / VIP. */
export function PromoBadge({ label }: { label: string }) {
  return (
    <span className="bg-tertiary/12 text-tertiary inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-semibold">
      <Tag aria-hidden className="size-2.5" />
      {label}
    </span>
  );
}

export function EventBadge({ label }: { label: string }) {
  return (
    <span className="bg-primary/12 text-primary inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-semibold">
      <CalendarDays aria-hidden className="size-2.5" />
      {label}
    </span>
  );
}

export function GoingCount({ count, className }: { count: number; className?: string }) {
  const t = useTranslations("device");
  return (
    <span
      className={cn(
        "text-on-surface-variant inline-flex items-center gap-1.5 text-[11px]",
        className
      )}
    >
      <Users aria-hidden className="text-primary size-3" />
      <span className="tabular-nums">{t("going", { count })}</span>
    </span>
  );
}

/* ── Feed card — one per FeedItem type ───────────────────────────────── */

export type FeedItemType =
  | "live_tonight"
  | "promo"
  | "event"
  | "editorial"
  | "going_milestone"
  | "venue_update";

export interface SampleFeedItem {
  id: string;
  type: FeedItemType;
  venue: SampleVenue;
  /** Key under device.items.* */
  bodyKey: string;
  going?: number;
}

export function FeedCard({ item, className }: { item: SampleFeedItem; className?: string }) {
  const t = useTranslations("device");

  if (item.type === "editorial") {
    return (
      <article className={cn("bg-surface-high rounded-md p-3", className)}>
        <p className="text-primary flex items-center gap-1.5 font-mono text-[9px] tracking-[0.14em] uppercase">
          <Sparkles aria-hidden className="size-3" />
          {t("editorial")}
        </p>
        <p className="font-display mt-1.5 text-[14px] leading-snug font-bold">
          {t(`items.${item.bodyKey}`)}
        </p>
      </article>
    );
  }

  if (item.type === "going_milestone") {
    return (
      <article
        className={cn("bg-surface-container flex items-center gap-3 rounded-md p-3", className)}
      >
        <span className="font-display text-primary text-2xl font-extrabold tabular-nums">
          {item.going}
        </span>
        <p className="text-on-surface-variant text-[11px] leading-snug">
          {t("goingMilestone", { count: item.going ?? 0 })}
          <span className="text-on-surface block font-semibold">{item.venue.name}</span>
        </p>
      </article>
    );
  }

  return (
    <article className={cn("bg-surface-container rounded-md p-3", className)}>
      <header className="flex items-center gap-2">
        <VenueAvatar venue={item.venue} />
        <div className="min-w-0 flex-1">
          <p className="truncate text-[12px] font-semibold">{item.venue.name}</p>
          <p className="text-muted truncate text-[10px]">
            {item.venue.kind} · {item.venue.area}
          </p>
        </div>
        {item.type === "live_tonight" && <LiveBadge label={t("live")} />}
        {item.type === "promo" && <PromoBadge label={t("promo")} />}
        {item.type === "event" && <EventBadge label={t("event")} />}
      </header>
      <p className="text-on-surface mt-2 text-[12px] leading-snug">{t(`items.${item.bodyKey}`)}</p>
      {item.going !== undefined && (
        <footer className="mt-2.5 flex items-center justify-between gap-2">
          <GoingCount count={item.going} />
          <span className="bg-primary text-on-primary shrink-0 rounded-full px-2.5 py-1 text-[10px] font-semibold whitespace-nowrap">
            {t("goCta")}
          </span>
        </footer>
      )}
    </article>
  );
}
