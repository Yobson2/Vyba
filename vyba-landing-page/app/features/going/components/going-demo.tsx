"use client";

import { useId, useState } from "react";
import { AnimatePresence, m } from "framer-motion";
import { Check, Users } from "lucide-react";
import { useTranslations } from "next-intl";
import { LiveBadge, VenueAvatar } from "@/app/components/device/device-ui";
import { sampleVenues } from "@/app/components/device/sample-venues";
import { Button } from "@/app/components/ui/button";
import { emphasized } from "@/app/lib/animations";
import { cn } from "@/app/lib/utils";

const BASE_COUNT = 23;
const PARTY_SIZES = [1, 2, 3, 4, 5, 6] as const;
const venue = sampleVenues.comptoir;

/** Mirrors the real "J'y vais" contract: one per night, party size, editable, aggregate only. */
export function GoingDemo() {
  const t = useTranslations("going.demo");
  const tDevice = useTranslations("device");
  const [party, setParty] = useState(2);
  const [going, setGoing] = useState(false);
  const legendId = useId();

  const count = BASE_COUNT + (going ? party : 0);

  return (
    <div className="bg-surface-container rounded-xl p-5 sm:p-8">
      <div className="flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between sm:gap-3">
        <p className="text-primary font-mono text-[11px] tracking-[0.14em] uppercase">
          {t("label")}
        </p>
        <p className="text-muted font-mono text-[11px]">{tDevice("caption")}</p>
      </div>

      <div className="mt-6 flex items-center gap-4">
        <VenueAvatar venue={venue} size="lg" />
        <div className="min-w-0 flex-1">
          <p className="font-display truncate text-xl font-bold tracking-[-0.02em]">{venue.name}</p>
          <p className="text-muted text-sm">
            {venue.kind} · {venue.area}
          </p>
        </div>
        <LiveBadge label={tDevice("live")} className="text-[11px]" />
      </div>

      <div className="bg-surface-low mt-8 flex items-end gap-4 rounded-lg p-5">
        <Users aria-hidden className="text-primary mb-2 size-6 shrink-0" />
        <p className="leading-tight">
          <span className="font-display relative inline-flex h-[1em] overflow-hidden text-6xl font-extrabold tracking-[-0.04em] tabular-nums">
            <AnimatePresence initial={false} mode="popLayout">
              <m.span
                key={count}
                initial={{ y: "100%", opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                exit={{ y: "-100%", opacity: 0 }}
                transition={emphasized(0.35)}
              >
                {count}
              </m.span>
            </AnimatePresence>
          </span>
          <span className="text-on-surface-variant mt-1 block">{t("countSuffix")}</span>
        </p>
      </div>
      <p aria-live="polite" className="sr-only">
        {going ? t("announce", { count }) : ""}
      </p>

      <fieldset className="mt-8" aria-describedby={`${legendId}-hint`}>
        <legend className="font-semibold">{t("partyLegend")}</legend>
        <p id={`${legendId}-hint`} className="text-muted mt-1 text-sm">
          {t("hint")}
        </p>
        <div className="mt-4 grid grid-cols-6 gap-2">
          {PARTY_SIZES.map((n) => (
            <label key={n} className="relative">
              <input
                type="radio"
                name={legendId}
                value={n}
                checked={party === n}
                onChange={() => setParty(n)}
                aria-label={t("partyOption", { count: n })}
                className="peer sr-only"
              />
              <span
                aria-hidden
                className={cn(
                  "font-display flex h-12 cursor-pointer items-center justify-center rounded-md text-lg font-bold tabular-nums transition-colors duration-200",
                  "peer-focus-visible:outline-primary peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2",
                  party === n
                    ? "bg-primary text-on-primary"
                    : "bg-surface-high text-on-surface-variant hover:bg-surface-highest"
                )}
              >
                {n}
              </span>
            </label>
          ))}
        </div>
      </fieldset>

      <div className="mt-6 flex flex-col gap-3">
        <Button
          size="lg"
          aria-pressed={going}
          onClick={() => setGoing((g) => !g)}
          className={cn(
            "w-full",
            going && "bg-secondary/15 text-secondary hover:bg-secondary/20 shadow-none"
          )}
        >
          {going && <Check aria-hidden className="size-5" />}
          {going ? tDevice("goneCta") : tDevice("goCta")}
        </Button>
        <p
          className={cn(
            "text-on-surface-variant min-h-6 text-center text-sm",
            !going && "invisible"
          )}
        >
          {t("confirmed")} {t("cancel")}
        </p>
      </div>
    </div>
  );
}
