import Image from "next/image";
import { useTranslations } from "next-intl";
import { Reveal } from "@/app/components/motion/reveal";
import { StoreButton, WhatsAppButton } from "@/app/components/ui/cta-links";
import { siteConfig } from "@/app/lib/constants";

/** Where Vyba is (ADR-0005: pilot in Zone 4, discovery city-wide) + the last call to action. */
export function FinalCtaSection() {
  const t = useTranslations("where");

  return (
    <section aria-labelledby="where-title" className="relative overflow-hidden">
      <div
        aria-hidden
        className="pointer-events-none absolute -bottom-64 left-1/2 -z-10 size-[720px] -translate-x-1/2 rounded-full bg-[radial-gradient(closest-side,rgb(108_92_231/0.22),transparent)]"
      />
      <Reveal className="container-page flex flex-col items-center py-24 text-center lg:py-36">
        <Image src={siteConfig.mark} width={56} height={56} alt="" className="size-14" />
        <p className="text-primary mt-8 font-mono text-xs tracking-[0.18em] uppercase">
          {t("eyebrow")}
        </p>
        <h2
          id="where-title"
          className="font-display mt-4 text-[2.75rem] leading-[0.98] font-extrabold tracking-[-0.045em] text-balance sm:text-7xl"
        >
          {t("title")}
        </h2>
        <p className="text-on-surface-variant mt-6 max-w-2xl text-lg leading-relaxed">
          {t("body")}
        </p>
        <p className="text-on-surface mt-8 font-mono text-sm tracking-[0.12em] uppercase">
          {t("kinds")}
        </p>

        <div className="mt-12 flex w-full flex-col items-center gap-3 sm:w-auto sm:flex-row">
          <StoreButton size="lg" className="w-full sm:w-auto" />
          <WhatsAppButton size="lg" className="w-full sm:w-auto" />
        </div>
      </Reveal>
    </section>
  );
}
