import { CalendarCheck, EyeOff, ShieldCheck, TicketX } from "lucide-react";
import { useTranslations } from "next-intl";
import { Reveal } from "@/app/components/motion/reveal";
import { SectionHeader } from "@/app/components/ui/section-header";
import { STAGGER } from "@/app/lib/animations";
import { GoingDemo } from "./going-demo";

// Each principle is a domain invariant (ADR-0002, CONTEXT.md "Key invariants") —
// this is the page's trust section, built on guarantees rather than testimonials.
const principles = [
  { key: "notBooking", icon: TicketX },
  { key: "private", icon: EyeOff },
  { key: "oncePerNight", icon: CalendarCheck },
  { key: "honest", icon: ShieldCheck },
] as const;

export function GoingSection() {
  const t = useTranslations("going");

  return (
    <section id="jy-vais" aria-labelledby="jy-vais-title" className="bg-surface-low">
      <div className="container-page py-24 lg:py-32">
        <SectionHeader
          id="jy-vais-title"
          eyebrow={t("eyebrow")}
          title={t("title")}
          lead={t("lead")}
        />

        <div className="mt-14 grid items-start gap-10 lg:grid-cols-[1.05fr_1fr] lg:gap-16">
          <Reveal>
            <GoingDemo />
          </Reveal>

          <ul className="grid gap-x-8 gap-y-10 sm:grid-cols-2 lg:pt-4">
            {principles.map(({ key, icon: Icon }, index) => (
              <Reveal as="li" key={key} delay={index * STAGGER * 2} y={16}>
                <span className="bg-surface-high flex size-11 items-center justify-center rounded-md">
                  <Icon aria-hidden className="text-primary size-5" />
                </span>
                <h3 className="font-display mt-4 text-lg font-bold tracking-[-0.02em]">
                  {t(`principles.${key}.title`)}
                </h3>
                <p className="text-on-surface-variant mt-2 leading-relaxed">
                  {t(`principles.${key}.body`)}
                </p>
              </Reveal>
            ))}
          </ul>
        </div>
      </div>
    </section>
  );
}
