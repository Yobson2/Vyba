import { Plus } from "lucide-react";
import { useTranslations } from "next-intl";
import { Reveal } from "@/app/components/motion/reveal";
import { SectionHeader } from "@/app/components/ui/section-header";

const faqKeys = ["free", "booking", "privacy", "phone", "iphone", "where", "venue"] as const;

export function FaqSection() {
  const t = useTranslations("faq");

  return (
    <section id="faq" aria-labelledby="faq-title" className="bg-surface-low">
      <div className="container-page grid gap-12 py-24 lg:grid-cols-[1fr_1.6fr] lg:gap-20 lg:py-32">
        <SectionHeader
          id="faq-title"
          eyebrow={t("eyebrow")}
          title={t("title")}
          className="lg:sticky lg:top-28 lg:self-start"
        />

        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "FAQPage",
              mainEntity: faqKeys.map((key) => ({
                "@type": "Question",
                name: t(`items.${key}.question`),
                acceptedAnswer: { "@type": "Answer", text: t(`items.${key}.answer`) },
              })),
            }).replace(/</g, "\\u003c"),
          }}
        />

        <Reveal className="flex flex-col gap-2">
          {/* Native <details>: keyboard and screen-reader support with zero JS. */}
          {faqKeys.map((key) => (
            <details
              key={key}
              className="group bg-surface-container open:bg-surface-high rounded-lg transition-colors"
            >
              <summary className="flex min-h-16 cursor-pointer list-none items-center justify-between gap-6 rounded-lg px-5 py-4 text-left font-semibold sm:px-6 [&::-webkit-details-marker]:hidden">
                {t(`items.${key}.question`)}
                <Plus
                  aria-hidden
                  className="text-primary size-5 shrink-0 transition-transform duration-300 ease-[var(--ease-emphasized)] group-open:rotate-45"
                />
              </summary>
              <p className="text-on-surface-variant px-5 pb-5 leading-relaxed sm:px-6 sm:pb-6">
                {t(`items.${key}.answer`)}
              </p>
            </details>
          ))}
        </Reveal>
      </div>
    </section>
  );
}
