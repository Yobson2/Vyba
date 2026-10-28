import { BarChart3, Megaphone, Radio } from "lucide-react";
import { useTranslations } from "next-intl";
import { Reveal } from "@/app/components/motion/reveal";
import { WhatsAppButton } from "@/app/components/ui/cta-links";
import { SectionHeader } from "@/app/components/ui/section-header";
import { STAGGER } from "@/app/lib/animations";
import { OwnerDemo } from "./owner-demo";

const features = [
  { key: "live", icon: Radio },
  { key: "post", icon: Megaphone },
  { key: "intent", icon: BarChart3 },
] as const;

// Owner accounts are provisioned by the team after a visit — no self-serve (spec §7).
const onboardingSteps = ["contact", "visit", "publish"] as const;

export function VenuesSection() {
  const t = useTranslations("venues");

  return (
    <section id="lieux" aria-labelledby="lieux-title">
      <div className="container-page py-24 lg:py-32">
        <SectionHeader
          id="lieux-title"
          eyebrow={t("eyebrow")}
          title={t("title")}
          lead={t("lead")}
        />

        <div className="mt-14 grid items-start gap-12 lg:grid-cols-[1fr_1.05fr] lg:gap-16">
          <ul className="flex flex-col gap-10 lg:order-none lg:pt-4">
            {features.map(({ key, icon: Icon }, index) => (
              <Reveal as="li" key={key} delay={index * STAGGER * 2} y={16} className="flex gap-5">
                <span className="bg-surface-high flex size-11 shrink-0 items-center justify-center rounded-md">
                  <Icon aria-hidden className="text-primary size-5" />
                </span>
                <div>
                  <h3 className="font-display text-xl font-bold tracking-[-0.02em]">
                    {t(`features.${key}.title`)}
                  </h3>
                  <p className="text-on-surface-variant mt-2 max-w-md leading-relaxed">
                    {t(`features.${key}.body`)}
                  </p>
                </div>
              </Reveal>
            ))}
          </ul>

          <Reveal className="order-first lg:order-none">
            <OwnerDemo />
          </Reveal>
        </div>

        <Reveal className="bg-surface-low mt-16 rounded-xl p-6 sm:p-10">
          <div className="flex flex-col gap-10 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <h3 className="font-display text-2xl font-bold tracking-[-0.02em]">
                {t("onboarding.title")}
              </h3>
              <ol className="mt-6 grid gap-6 sm:grid-cols-3 sm:gap-8">
                {onboardingSteps.map((key, index) => (
                  <li key={key} className="flex gap-4 sm:flex-col sm:gap-3">
                    <span className="bg-surface-high text-primary flex size-8 shrink-0 items-center justify-center rounded-full font-mono text-xs">
                      {index + 1}
                    </span>
                    <p className="text-on-surface-variant leading-relaxed sm:max-w-[16rem]">
                      {t(`onboarding.steps.${key}`)}
                    </p>
                  </li>
                ))}
              </ol>
            </div>
            <div className="flex flex-col gap-3 lg:items-end">
              <WhatsAppButton size="lg" variant="primary" className="w-full sm:w-auto" />
              <p className="text-muted text-sm">{t("onboarding.note")}</p>
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
