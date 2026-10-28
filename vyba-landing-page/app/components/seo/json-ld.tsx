import { getTranslations } from "next-intl/server";
import { siteConfig } from "@/app/lib/constants";

interface JsonLdProps {
  locale: string;
}

export async function JsonLd({ locale }: JsonLdProps) {
  const t = await getTranslations({ locale, namespace: "metadata" });

  // Only facts we can stand behind: no address, phone or ratings we don't have.
  const structuredData = [
    {
      "@context": "https://schema.org",
      "@type": "Organization",
      name: siteConfig.name,
      url: siteConfig.url,
      logo: `${siteConfig.url}/apple-icon.png`,
      description: t("description"),
      areaServed: { "@type": "City", name: "Abidjan" },
      ...(siteConfig.email ? { email: siteConfig.email } : {}),
    },
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      url: siteConfig.url,
      name: siteConfig.name,
      description: t("description"),
      inLanguage: locale,
    },
  ];

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData).replace(/</g, "\\u003c") }}
    />
  );
}
