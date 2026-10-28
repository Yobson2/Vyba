"use client";

import { useId, useState } from "react";
import { Camera, Check, Disc3, Music, Tag } from "lucide-react";
import { useTranslations } from "next-intl";
import { VenueAvatar } from "@/app/components/device/device-ui";
import { sampleVenues } from "@/app/components/device/sample-venues";
import { cn } from "@/app/lib/utils";

// The spec's one-tap venue actions (§3.4 "Low-friction venue content").
const quickActions = [
  { key: "dj", icon: Disc3 },
  { key: "happyHour", icon: Tag },
  { key: "liveMusic", icon: Music },
  { key: "photo", icon: Camera },
] as const;

type ActionKey = (typeof quickActions)[number]["key"];

const venue = sampleVenues.comptoir;

export function OwnerDemo() {
  const t = useTranslations("venues.demo");
  const tDevice = useTranslations("device");
  const [live, setLive] = useState(false);
  const [posted, setPosted] = useState<Set<ActionKey>>(new Set());
  const switchId = useId();

  const toggle = (key: ActionKey) =>
    setPosted((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });

  return (
    <div className="bg-surface-container rounded-xl p-5 sm:p-8">
      <div className="flex items-center justify-between gap-3">
        <p className="text-primary font-mono text-[11px] tracking-[0.14em] uppercase">
          {t("label")}
        </p>
      </div>

      <div className="mt-6 flex items-center gap-4">
        <VenueAvatar venue={venue} size="lg" />
        <div>
          <p className="text-muted text-sm">{t("venueTonight")}</p>
          <p className="font-display text-xl font-bold tracking-[-0.02em]">{venue.name}</p>
        </div>
      </div>

      {/* Live switch — emerald only once the venue is actually live. */}
      <div
        className={cn(
          "mt-6 flex items-center justify-between gap-4 rounded-lg p-4 transition-colors duration-300",
          live ? "bg-secondary/12" : "bg-surface-low"
        )}
      >
        <div>
          <label htmlFor={switchId} className="cursor-pointer font-semibold">
            {t("liveSwitch")}
          </label>
          <p
            aria-live="polite"
            className={cn("mt-0.5 text-sm", live ? "text-secondary" : "text-muted")}
          >
            {live ? t("liveOn") : t("liveOff")}
          </p>
        </div>
        <button
          id={switchId}
          type="button"
          role="switch"
          aria-checked={live}
          onClick={() => setLive((l) => !l)}
          className={cn(
            "relative h-8 w-14 shrink-0 rounded-full transition-colors duration-300",
            live ? "bg-secondary" : "bg-surface-highest"
          )}
        >
          <span
            className={cn(
              "absolute top-1 left-1 size-6 rounded-full transition-transform duration-300 ease-[var(--ease-emphasized)]",
              live ? "bg-on-secondary translate-x-6" : "bg-on-surface-variant"
            )}
          />
        </button>
      </div>

      <p className="mt-6 text-sm font-semibold">{t("quickPost")}</p>
      <ul className="mt-3 grid grid-cols-2 gap-2">
        {quickActions.map(({ key, icon: Icon }) => {
          const isPosted = posted.has(key);
          return (
            <li key={key}>
              <button
                type="button"
                aria-pressed={isPosted}
                onClick={() => toggle(key)}
                className={cn(
                  "flex h-12 w-full items-center gap-2.5 rounded-md px-3.5 text-left text-sm font-medium transition-colors duration-200 active:scale-[0.98]",
                  isPosted
                    ? "bg-primary/15 text-primary"
                    : "bg-surface-high hover:bg-surface-highest"
                )}
              >
                {isPosted ? (
                  <Check aria-hidden className="size-4 shrink-0" />
                ) : (
                  <Icon
                    aria-hidden
                    className={cn(
                      "size-4 shrink-0",
                      key === "happyHour" ? "text-tertiary" : "text-primary"
                    )}
                  />
                )}
                <span className="truncate">{t(`actions.${key}`)}</span>
              </button>
            </li>
          );
        })}
      </ul>
      <p
        aria-live="polite"
        className={cn("text-primary mt-2 min-h-5 text-xs", posted.size === 0 && "invisible")}
      >
        {t("quickPosted")}
      </p>

      <dl className="mt-4 grid grid-cols-2 gap-2">
        <div className="bg-surface-low rounded-lg p-4">
          <dt className="text-muted text-xs">{t("goingLabel")}</dt>
          <dd className="font-display mt-1 text-3xl font-extrabold tracking-[-0.03em] tabular-nums">
            23
          </dd>
        </div>
        <div className="bg-surface-low rounded-lg p-4">
          <dt className="text-muted text-xs">{t("groupsLabel")}</dt>
          <dd className="mt-1.5 text-sm font-semibold">{t("groupsValue", { count: 7 })}</dd>
        </div>
      </dl>
      <p className="text-muted mt-4 font-mono text-[11px]">{tDevice("caption")}</p>
    </div>
  );
}
