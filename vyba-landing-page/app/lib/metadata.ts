import type { Metadata } from "next";
import { siteConfig } from "./constants";

const ogImage = {
  url: siteConfig.ogImage,
  width: 1200,
  height: 630,
  alt: "Vyba — On bouge où ce soir ?",
};

export function constructMetadata(overrides?: Partial<Metadata>): Metadata {
  const { openGraph, twitter, ...rest } = overrides ?? {};
  const title = overrides?.title ?? siteConfig.name;
  const description = overrides?.description ?? siteConfig.name;
  const plainTitle =
    typeof title === "string"
      ? title
      : title && "default" in title
        ? title.default
        : siteConfig.name;
  const plainDescription = typeof description === "string" ? description : siteConfig.name;

  return {
    title: overrides?.title ?? {
      default: siteConfig.name,
      template: `%s | ${siteConfig.name}`,
    },
    description,
    metadataBase: new URL(siteConfig.url),
    openGraph: {
      type: "website",
      url: siteConfig.url,
      title: plainTitle,
      description: plainDescription,
      siteName: siteConfig.name,
      locale: "fr_CI",
      images: [ogImage],
      ...openGraph,
    },
    twitter: {
      card: "summary_large_image",
      images: [ogImage.url],
      title: plainTitle,
      description: plainDescription,
      ...twitter,
    },
    appleWebApp: {
      title: siteConfig.name,
      capable: true,
      statusBarStyle: "black-translucent",
    },
    ...rest,
  };
}
