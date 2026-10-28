import Image from "next/image";
import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { navLinks, siteConfig } from "@/app/lib/constants";

export function Footer() {
  const t = useTranslations("footer");
  const tNav = useTranslations("nav");

  return (
    <footer className="bg-surface-low">
      <div className="container-page grid gap-12 py-16 sm:grid-cols-2 lg:grid-cols-[2fr_1fr_1fr]">
        <div className="flex max-w-xs flex-col gap-4">
          <Link href="/" aria-label={tNav("home")} className="w-fit">
            <Image src={siteConfig.logo} width={96} height={30} alt="" className="h-7 w-auto" />
          </Link>
          <p className="text-on-surface-variant text-sm leading-relaxed">{t("tagline")}</p>
        </div>

        <nav aria-labelledby="footer-product">
          <p
            id="footer-product"
            className="text-muted font-mono text-xs tracking-[0.18em] uppercase"
          >
            {t("product")}
          </p>
          <ul className="mt-4 flex flex-col gap-1">
            {navLinks.map((link) => (
              <li key={link.href}>
                <Link
                  href={link.href}
                  className="text-on-surface-variant hover:text-on-surface inline-block py-1.5 text-sm transition-colors"
                >
                  {tNav(link.textKey)}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <nav aria-labelledby="footer-legal">
          <p id="footer-legal" className="text-muted font-mono text-xs tracking-[0.18em] uppercase">
            {t("legal")}
          </p>
          <ul className="mt-4 flex flex-col gap-1">
            <li>
              <Link
                href="/legal"
                className="text-on-surface-variant hover:text-on-surface inline-block py-1.5 text-sm transition-colors"
              >
                {t("privacy")}
              </Link>
            </li>
            {siteConfig.whatsappUrl && (
              <li>
                <a
                  href={siteConfig.whatsappUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-on-surface-variant hover:text-on-surface inline-block py-1.5 text-sm transition-colors"
                >
                  {t("help")} WhatsApp
                </a>
              </li>
            )}
          </ul>
        </nav>
      </div>

      <div className="bg-surface">
        <p className="container-page text-muted py-6 text-xs">
          {t("copyright", { year: new Date().getFullYear() })}
        </p>
      </div>
    </footer>
  );
}
