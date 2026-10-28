import { ArrowRight } from "lucide-react";
import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { PhoneFrame } from "@/app/components/device/phone-frame";
import { StoreButton } from "@/app/components/ui/cta-links";
import { buttonStyles } from "@/app/components/ui/button";
import { LiveFeedPreview } from "./live-feed-preview";

export function HeroSection() {
  const t = useTranslations("hero");
  const tDevice = useTranslations("device");

  return (
    <section aria-labelledby="hero-title" className="relative overflow-hidden">
      <div className="container-page grid items-center gap-14 pt-8 pb-16 sm:pt-14 lg:grid-cols-[1.15fr_1fr] lg:gap-8 lg:pt-16 lg:pb-28">
        {/* Copy is server-rendered and unanimated: it is the LCP and must paint immediately. */}
        <div className="flex flex-col items-start">
          <p className="bg-surface-high text-on-surface-variant inline-flex items-center gap-2 rounded-full px-3.5 py-1.5 font-mono text-[11px] tracking-[0.14em] uppercase">
            <span aria-hidden className="bg-primary size-1.5 rounded-full" />
            {t("eyebrow")}
          </p>

          <h1
            id="hero-title"
            className="font-display mt-6 text-[3.25rem] leading-[0.95] font-extrabold tracking-[-0.045em] text-balance sm:text-7xl lg:text-[5.25rem]"
          >
            {t("title")}
          </h1>

          <p className="text-on-surface-variant mt-6 max-w-xl text-lg leading-relaxed sm:text-xl">
            {t("lead")}
          </p>

          <div className="mt-9 flex w-full flex-col gap-3 sm:w-auto sm:flex-row sm:items-center">
            <StoreButton size="lg" className="w-full sm:w-auto" />
            <Link
              href="/#lieux"
              className={buttonStyles({ variant: "ghost", size: "lg", className: "group" })}
            >
              {t("secondary")}
              <ArrowRight
                aria-hidden
                className="size-4 transition-transform group-hover:translate-x-0.5"
              />
            </Link>
          </div>

          <p className="text-muted mt-5 text-sm">{t("note")}</p>
        </div>

        <figure className="relative mx-auto flex flex-col items-center">
          {/* One light source behind the device — the only glow on the page. */}
          <div
            aria-hidden
            className="pointer-events-none absolute top-1/2 left-1/2 -z-10 size-[560px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(closest-side,rgb(108_92_231/0.32),transparent)]"
          />
          {/* Mobile: show the top of the device and let it fade — a glimpse, not a wall. */}
          <div className="max-h-[480px] overflow-hidden [mask-image:linear-gradient(to_bottom,#000_72%,transparent)] sm:max-h-none sm:[mask-image:none]">
            <PhoneFrame>
              <div
                role="img"
                aria-label={t("previewLabel")}
                className="flex min-h-0 flex-1 flex-col"
              >
                <LiveFeedPreview />
              </div>
            </PhoneFrame>
          </div>
          <figcaption className="text-muted mt-5 font-mono text-[11px] tracking-[0.08em]">
            {tDevice("caption")}
          </figcaption>
        </figure>
      </div>
    </section>
  );
}
