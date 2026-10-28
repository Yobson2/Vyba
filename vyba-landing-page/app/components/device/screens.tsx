import { Check, Disc3, MapPin, Search, Tag } from "lucide-react";
import { useTranslations } from "next-intl";
import { cn } from "@/app/lib/utils";
import { FeedCard, GoingCount, LiveBadge, VenueAvatar, type SampleFeedItem } from "./device-ui";
import { sampleVenues as v } from "./sample-venues";

/* Code-rendered screens of the Vyba app. Every string is sample content. */

export function FeedHeader({ withSearch = true }: { withSearch?: boolean }) {
  const t = useTranslations("device");
  return (
    <div className="shrink-0 px-4 pt-2 pb-3">
      <div className="flex items-center justify-between">
        <p className="font-display text-xl font-extrabold tracking-[-0.02em]">{t("tonight")}</p>
        <span className="bg-surface-high text-on-surface-variant inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-[10px] font-medium">
          <MapPin aria-hidden className="text-primary size-3" />
          {t("area")}
        </span>
      </div>
      {withSearch && (
        <>
          <div className="bg-surface-container text-muted mt-3 flex h-8 items-center gap-2 rounded-sm px-3 text-[11px]">
            <Search aria-hidden className="size-3.5" />
            {t("search")}
          </div>
          <div className="mt-2.5 flex gap-1.5 text-[10px] font-semibold">
            <span className="bg-primary text-on-primary rounded-full px-2.5 py-1">
              {t("tonight")}
            </span>
            <span className="bg-surface-high text-on-surface-variant rounded-full px-2.5 py-1">
              {t("nearby")}
            </span>
          </div>
        </>
      )}
    </div>
  );
}

export const discoverItems: SampleFeedItem[] = [
  { id: "d1", type: "live_tonight", venue: v.comptoir, bodyKey: "liveUpdate", going: 23 },
  { id: "d2", type: "promo", venue: v.onyx, bodyKey: "promo", going: 9 },
  { id: "d3", type: "event", venue: v.bloc, bodyKey: "event", going: 41 },
];

export function FeedScreen({ items = discoverItems }: { items?: SampleFeedItem[] }) {
  return (
    <>
      <FeedHeader />
      <div className="flex flex-col gap-2 px-3">
        {items.map((item) => (
          <FeedCard key={item.id} item={item} />
        ))}
      </div>
    </>
  );
}

/** The venue-night page: everything that is true for *this venue tonight* (ADR-0001). */
export function VenueNightScreen({
  going = 23,
  goingActive = false,
  className,
}: {
  going?: number;
  goingActive?: boolean;
  className?: string;
}) {
  const t = useTranslations("device");
  return (
    <div className={cn("flex flex-1 flex-col", className)}>
      <div className="relative mx-3 flex h-32 items-end rounded-lg bg-[radial-gradient(120%_90%_at_80%_0%,#2a2470_0%,#111f3a_55%,#0c1a32_100%)] p-3">
        <LiveBadge label={t("live")} className="absolute top-3 left-3" />
        <VenueAvatar venue={v.comptoir} size="lg" />
      </div>
      <div className="px-4 pt-3">
        <p className="font-display text-xl font-extrabold tracking-[-0.02em]">{v.comptoir.name}</p>
        <p className="text-muted text-[11px]">
          {v.comptoir.kind} · {v.comptoir.area}
        </p>
      </div>
      <div className="mt-3 flex flex-col gap-2 px-3">
        <div className="bg-surface-container flex items-center gap-3 rounded-md p-3">
          <Disc3 aria-hidden className="text-primary size-4" />
          <div>
            <p className="text-muted text-[10px]">{t("decks")}</p>
            <p className="text-[12px] font-semibold">{t("items.decksValue")}</p>
          </div>
        </div>
        <div className="bg-surface-container flex items-center gap-3 rounded-md p-3">
          <Tag aria-hidden className="text-tertiary size-4" />
          <div>
            <p className="text-muted text-[10px]">{t("tonightOffer")}</p>
            <p className="text-[12px] font-semibold">{t("items.promo")}</p>
          </div>
        </div>
      </div>
      <div className="mt-auto px-3 pb-4">
        <GoingCount count={going} className="mb-2 w-full justify-center" />
        <span
          className={cn(
            "flex h-10 items-center justify-center gap-1.5 rounded-full text-[13px] font-semibold",
            goingActive ? "bg-secondary/15 text-secondary" : "bg-primary text-on-primary"
          )}
        >
          {goingActive && <Check aria-hidden className="size-4" />}
          {goingActive ? t("goneCta") : t("goCta")}
        </span>
      </div>
    </div>
  );
}

export function GoingSheetScreen() {
  const t = useTranslations("device");
  return (
    <div className="relative flex flex-1 flex-col">
      <VenueNightScreen />
      <div className="bg-surface/70 absolute inset-0" />
      <div className="bg-surface-high shadow-floating absolute inset-x-0 bottom-0 rounded-t-xl px-4 pt-3 pb-5">
        <span className="bg-surface-bright mx-auto block h-1 w-9 rounded-full" />
        <p className="font-display mt-3 text-[15px] font-bold">{t("partyQuestion")}</p>
        <div className="mt-3 grid grid-cols-6 gap-1.5">
          {[1, 2, 3, 4, 5, 6].map((n) => (
            <span
              key={n}
              className={cn(
                "flex h-9 items-center justify-center rounded-sm text-[13px] font-semibold tabular-nums",
                n === 4
                  ? "bg-primary text-on-primary"
                  : "bg-surface-container text-on-surface-variant"
              )}
            >
              {n}
            </span>
          ))}
        </div>
        <span className="bg-primary text-on-primary mt-4 flex h-10 items-center justify-center rounded-full text-[13px] font-semibold">
          {t("confirm")}
        </span>
      </div>
    </div>
  );
}

export const liveItems: SampleFeedItem[] = [
  { id: "l1", type: "live_tonight", venue: v.bloc, bodyKey: "djStart", going: 52 },
  { id: "l2", type: "going_milestone", venue: v.comptoir, bodyKey: "liveUpdate", going: 30 },
  { id: "l3", type: "live_tonight", venue: v.tantie, bodyKey: "maquis", going: 17 },
];

export function FollowScreen() {
  const t = useTranslations("device");
  const followed = [v.comptoir, v.onyx, v.tantie, v.terrasse];
  return (
    <>
      <div className="px-4 pt-2 pb-3">
        <p className="font-display text-xl font-extrabold tracking-[-0.02em]">{t("yourPlaces")}</p>
        <ul className="mt-3 flex gap-3">
          {followed.map((venue) => (
            <li key={venue.name} className="flex w-12 flex-col items-center gap-1">
              <VenueAvatar venue={venue} size="lg" />
              <span className="text-on-surface-variant w-full truncate text-center text-[9px]">
                {venue.name}
              </span>
            </li>
          ))}
        </ul>
      </div>
      <div className="flex flex-col gap-2 px-3">
        <p className="text-muted px-1 font-mono text-[9px] tracking-[0.14em] uppercase">
          {t("weekend")}
        </p>
        <FeedCard
          item={{ id: "f1", type: "event", venue: v.onyx, bodyKey: "weekend", going: 12 }}
        />
        <p className="text-muted mt-1 px-1 font-mono text-[9px] tracking-[0.14em] uppercase">
          {t("upcoming")}
        </p>
        <FeedCard
          item={{ id: "f2", type: "venue_update", venue: v.terrasse, bodyKey: "upcoming" }}
        />
      </div>
    </>
  );
}
