import { setRequestLocale, getTranslations } from "next-intl/server";
import { constructMetadata } from "@/app/lib/metadata";
import { siteConfig } from "@/app/lib/constants";

type Props = {
  params: Promise<{ locale: string }>;
};

// TODO(legal): have counsel review this page and add the legal entity details
// before the public launch. Content reflects the validation spec (§7, §4, ADR-0003).

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "legal" });

  return constructMetadata({
    title: t("title"),
    description: t("metaDescription"),
    alternates: { canonical: "/legal" },
  });
}

const appItems = ["phone", "activity", "source", "location"] as const;

export default async function LegalPage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);

  const t = await getTranslations({ locale, namespace: "legal" });
  const contactHref = siteConfig.email ? `mailto:${siteConfig.email}` : siteConfig.whatsappUrl;
  const contactLabel = siteConfig.email ?? "WhatsApp";

  return (
    <main id="main" tabIndex={-1} className="outline-none">
      <div className="container-page max-w-3xl py-16 lg:py-24">
        <p className="text-primary font-mono text-xs tracking-[0.18em] uppercase">
          {t("lastUpdated")}
        </p>
        <h1 className="font-display mt-4 text-5xl font-extrabold tracking-[-0.04em] sm:text-6xl">
          {t("title")}
        </h1>
        <p className="text-on-surface-variant mt-6 text-lg leading-relaxed">{t("intro")}</p>

        <div className="mt-12 flex flex-col gap-3">
          <section aria-labelledby="legal-site" className="bg-surface-low rounded-lg p-6 sm:p-8">
            <h2 id="legal-site" className="font-display text-xl font-bold tracking-[-0.02em]">
              {t("site.title")}
            </h2>
            <p className="text-on-surface-variant mt-3 leading-relaxed">{t("site.content")}</p>
          </section>

          <section aria-labelledby="legal-app" className="bg-surface-low rounded-lg p-6 sm:p-8">
            <h2 id="legal-app" className="font-display text-xl font-bold tracking-[-0.02em]">
              {t("app.title")}
            </h2>
            <ul className="mt-4 flex flex-col gap-3">
              {appItems.map((key) => (
                <li key={key} className="text-on-surface-variant flex gap-3 leading-relaxed">
                  <span aria-hidden className="bg-primary mt-2.5 size-1.5 shrink-0 rounded-full" />
                  {t(`app.items.${key}`)}
                </li>
              ))}
            </ul>
          </section>

          <section
            aria-labelledby="legal-visibility"
            className="bg-surface-low rounded-lg p-6 sm:p-8"
          >
            <h2 id="legal-visibility" className="font-display text-xl font-bold tracking-[-0.02em]">
              {t("visibility.title")}
            </h2>
            <p className="text-on-surface-variant mt-3 leading-relaxed">
              {t("visibility.content")}
            </p>
          </section>

          <section aria-labelledby="legal-rights" className="bg-surface-low rounded-lg p-6 sm:p-8">
            <h2 id="legal-rights" className="font-display text-xl font-bold tracking-[-0.02em]">
              {t("rights.title")}
            </h2>
            <p className="text-on-surface-variant mt-3 leading-relaxed">{t("rights.content")}</p>
            <p className="text-on-surface-variant mt-3 leading-relaxed">
              {contactHref ? (
                <>
                  {t("rights.contactWith")}{" "}
                  <a
                    href={contactHref}
                    className="text-primary font-semibold underline-offset-4 hover:underline"
                  >
                    {contactLabel}
                  </a>
                </>
              ) : (
                t("rights.contactPending")
              )}
            </p>
          </section>
        </div>
      </div>
    </main>
  );
}
