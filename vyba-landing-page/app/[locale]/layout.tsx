import { NextIntlClientProvider, hasLocale } from "next-intl";
import { setRequestLocale, getTranslations } from "next-intl/server";
import { notFound } from "next/navigation";
import { routing } from "@/app/i18n/routing";
import { Navbar } from "@/app/components/layout/navbar";
import { Footer } from "@/app/components/layout/footer";
import { MotionProvider } from "@/app/components/motion/motion-provider";
import { JsonLd } from "@/app/components/seo/json-ld";
import { constructMetadata } from "@/app/lib/metadata";
import { siteConfig } from "@/app/lib/constants";

type Props = {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
};

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "metadata" });

  return constructMetadata({
    title: { default: t("title"), template: `%s | ${siteConfig.name}` },
    description: t("description"),
    alternates: { canonical: "/" },
  });
}

export default async function LocaleLayout({ children, params }: Props) {
  const { locale } = await params;

  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  setRequestLocale(locale);

  const t = await getTranslations({ locale, namespace: "nav" });

  return (
    <NextIntlClientProvider>
      <MotionProvider>
        <JsonLd locale={locale} />
        <a
          href="#main"
          className="focus:bg-primary focus:text-on-primary sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-[200] focus:rounded-full focus:px-5 focus:py-3 focus:font-semibold"
        >
          {t("skipToContent")}
        </a>
        <Navbar />
        {children}
        <Footer />
      </MotionProvider>
    </NextIntlClientProvider>
  );
}
