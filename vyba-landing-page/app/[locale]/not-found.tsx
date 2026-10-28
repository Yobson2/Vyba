import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { buttonStyles } from "@/app/components/ui/button";

export default function NotFound() {
  const t = useTranslations("errors");

  return (
    <main
      id="main"
      className="container-page flex min-h-[70vh] flex-col items-center justify-center gap-6 text-center"
    >
      <p className="text-primary font-mono text-sm tracking-[0.18em]">{t("notFoundCode")}</p>
      <h1 className="font-display text-4xl font-extrabold tracking-[-0.03em] sm:text-5xl">
        {t("notFoundTitle")}
      </h1>
      <p className="text-on-surface-variant max-w-md text-lg">{t("notFoundDescription")}</p>
      <Link href="/" className={buttonStyles({ size: "lg" })}>
        {t("notFoundCta")}
      </Link>
    </main>
  );
}
