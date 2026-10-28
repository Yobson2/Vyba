"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { PhoneFrame } from "@/app/components/device/phone-frame";
import {
  FeedScreen,
  FollowScreen,
  GoingSheetScreen,
  VenueNightScreen,
  liveItems,
} from "@/app/components/device/screens";
import { SectionHeader } from "@/app/components/ui/section-header";
import { cn } from "@/app/lib/utils";

// The core loop (CONTEXT.md): Découvre → Vois → J'y vais → Vis la soirée → Reviens.
const steps = [
  { key: "discover", time: "19:00", Screen: () => <FeedScreen /> },
  { key: "see", time: "20:30", Screen: () => <VenueNightScreen /> },
  { key: "go", time: "22:00", Screen: () => <GoingSheetScreen /> },
  { key: "live", time: "23:30", Screen: () => <FeedScreen items={liveItems} /> },
  { key: "return", time: "—", Screen: () => <FollowScreen /> },
] as const;

function StepScreen({ index, className }: { index: number; className?: string }) {
  const { Screen, time } = steps[index]!;
  return (
    <PhoneFrame time={time === "—" ? "19:02" : time} className={className}>
      <div className="flex min-h-0 flex-1 flex-col">
        <Screen />
      </div>
    </PhoneFrame>
  );
}

export function JourneySection() {
  const t = useTranslations("journey");
  const tDevice = useTranslations("device");
  const [active, setActive] = useState(0);
  const stepRefs = useRef<(HTMLLIElement | null)[]>([]);

  // The step crossing the vertical centre of the viewport drives the pinned device.
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) setActive(Number((entry.target as HTMLElement).dataset.index));
        }
      },
      { rootMargin: "-50% 0px -50% 0px" }
    );
    stepRefs.current.forEach((el) => el && observer.observe(el));
    return () => observer.disconnect();
  }, []);

  return (
    <section id="ce-soir" aria-labelledby="ce-soir-title">
      <div className="container-page py-24 lg:py-32">
        <SectionHeader
          id="ce-soir-title"
          eyebrow={t("eyebrow")}
          title={t("title")}
          lead={t("lead")}
        />

        <div className="mt-16 lg:mt-8 lg:grid lg:grid-cols-[1fr_minmax(0,420px)] lg:gap-16">
          <ol aria-label={t("stepsLabel")} className="flex flex-col gap-20 lg:gap-0">
            {steps.map(({ key }, index) => {
              const isActive = active === index;
              return (
                <li
                  key={key}
                  ref={(el) => {
                    stepRefs.current[index] = el;
                  }}
                  data-index={index}
                  aria-current={isActive ? "step" : undefined}
                  className="flex flex-col gap-8 lg:min-h-[78vh] lg:justify-center"
                >
                  <div
                    className={cn(
                      "max-w-md transition-opacity duration-500 ease-[var(--ease-emphasized)]",
                      !isActive && "lg:opacity-70" // dimmed, yet body text stays >= 4.5:1
                    )}
                  >
                    <p
                      className={cn(
                        "inline-flex rounded-full px-3 py-1 font-mono text-xs tabular-nums transition-colors duration-500",
                        isActive ? "bg-primary text-on-primary" : "bg-surface-high text-on-surface"
                      )}
                    >
                      {t(`steps.${key}.time`)}
                    </p>
                    <h3 className="font-display mt-4 text-3xl font-bold tracking-[-0.03em] sm:text-4xl">
                      {t(`steps.${key}.title`)}
                    </h3>
                    <p className="text-on-surface-variant mt-3 text-lg leading-relaxed">
                      {t(`steps.${key}.body`)}
                    </p>
                  </div>

                  {/* Mobile & tablet: each step carries its own screen. */}
                  <div
                    aria-hidden
                    // Whole device, scaled down: every screen's key UI (e.g. the
                    // party-size sheet) sits at a different height, so never crop.
                    className="mx-auto [zoom:0.82] sm:[zoom:1] lg:hidden"
                  >
                    <StepScreen index={index} />
                  </div>
                </li>
              );
            })}
          </ol>

          {/* Desktop: one pinned device; screens crossfade as the story advances. */}
          <div className="hidden lg:block">
            <figure className="sticky top-0 flex h-dvh flex-col items-center justify-center">
              <div aria-hidden className="relative">
                {steps.map(({ key }, index) => (
                  <div
                    key={key}
                    className={cn(
                      "transition-[opacity,transform] duration-500 ease-[var(--ease-emphasized)]",
                      index === 0 ? "relative" : "absolute inset-0",
                      active === index
                        ? "opacity-100"
                        : "pointer-events-none translate-y-3 opacity-0"
                    )}
                  >
                    <StepScreen
                      index={index}
                      // Fit the pinned device to short laptop viewports (9:19.5 ≈ 0.4615).
                      className="sm:w-[min(300px,calc((100dvh-7rem)*0.4615))]"
                    />
                  </div>
                ))}
              </div>
              <figcaption className="text-muted mt-5 font-mono text-[11px] tracking-[0.08em]">
                {tDevice("caption")}
              </figcaption>
            </figure>
          </div>
        </div>
      </div>
    </section>
  );
}
