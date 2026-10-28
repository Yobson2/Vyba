"use client";

import { useTranslations } from "next-intl";
import { Button } from "@/app/components/ui/button";

interface ErrorPageProps {
  error: Error & { digest?: string };
  reset: () => void;
}

// No console logging here: error payloads can carry request data (docs/security.md).
export default function ErrorPage({ reset }: ErrorPageProps) {
  const t = useTranslations("errors");

  return (
    <main
      id="main"
      className="container-page flex min-h-[70vh] flex-col items-center justify-center gap-6 text-center"
    >
      <h1 className="font-display text-4xl font-extrabold tracking-[-0.03em]">
        {t("genericTitle")}
      </h1>
      <p className="text-on-surface-variant max-w-md text-lg">{t("genericDescription")}</p>
      <Button size="lg" onClick={reset}>
        {t("genericCta")}
      </Button>
    </main>
  );
}
