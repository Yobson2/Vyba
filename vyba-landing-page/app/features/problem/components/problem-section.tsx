import { CalendarDays, Compass, Users } from "lucide-react";
import { useTranslations } from "next-intl";
import { Reveal } from "@/app/components/motion/reveal";
import { SectionHeader } from "@/app/components/ui/section-header";
import { STAGGER } from "@/app/lib/animations";

// The three things Vyba centralises (CONTEXT.md — "What Vyba is").
const items = [
  { key: "discover", icon: Compass },
  { key: "announce", icon: CalendarDays },
  { key: "coordinate", icon: Users },
] as const;

export function ProblemSection() {
  const t = useTranslations("problem");

  return (
    <section aria-labelledby="probleme-title" className="bg-surface-low">
      <div className="container-page grid gap-12 py-24 lg:grid-cols-[1fr_1.1fr] lg:gap-20 lg:py-32">
        <SectionHeader
          id="probleme-title"
          eyebrow={t("eyebrow")}
          title={t("title")}
          lead={t("lead")}
        />

        <ol className="flex flex-col gap-3 self-end">
          {items.map(({ key, icon: Icon }, index) => (
            <Reveal
              as="li"
              key={key}
              delay={index * STAGGER * 2}
              y={16}
              className="bg-surface-container flex gap-5 rounded-lg p-6"
            >
              <span className="text-muted font-mono text-xs tabular-nums">0{index + 1}</span>
              <div className="flex-1">
                <h3 className="font-display flex items-center gap-2.5 text-xl font-bold tracking-[-0.02em]">
                  <Icon aria-hidden className="text-primary size-5" />
                  {t(`items.${key}.title`)}
                </h3>
                <p className="text-on-surface-variant mt-2 leading-relaxed">
                  {t(`items.${key}.body`)}
                </p>
              </div>
            </Reveal>
          ))}
        </ol>
      </div>
    </section>
  );
}
