import { ArrowDownToLine, Clock, MessageCircle } from "lucide-react";
import { useTranslations } from "next-intl";
import { buttonStyles } from "@/app/components/ui/button";
import { siteConfig } from "@/app/lib/constants";
import { cn } from "@/app/lib/utils";

type Size = "sm" | "md" | "lg";

interface CtaProps {
  size?: Size;
  short?: boolean;
  className?: string;
}

/** Not-yet-available state: honest, visibly inert, and announced as such. */
function Pending({
  label,
  size = "md",
  className,
}: {
  label: string;
  size?: Size;
  className?: string;
}) {
  return (
    <span
      aria-disabled="true"
      className={buttonStyles({
        variant: "tonal",
        size,
        className: cn(
          "text-on-surface-variant hover:bg-surface-high cursor-default active:scale-100",
          className
        ),
      })}
    >
      <Clock aria-hidden className="size-4" />
      {label}
    </span>
  );
}

/** Primary client CTA. Android-first: Google Play (spec §15). */
export function StoreButton({ size = "md", short = false, className }: CtaProps) {
  const t = useTranslations("cta");

  if (!siteConfig.playStoreUrl) {
    return <Pending label={t("playStoreSoon")} size={size} className={className} />;
  }

  return (
    <a
      href={siteConfig.playStoreUrl}
      target="_blank"
      rel="noopener noreferrer"
      className={buttonStyles({ variant: "primary", size, className })}
    >
      <ArrowDownToLine aria-hidden className="size-[1.15em]" />
      {short ? t("playStoreShort") : t("playStore")}
      <span className="sr-only"> {t("newTab")}</span>
    </a>
  );
}

/** Venue-owner / support CTA. WhatsApp Business is the support channel (spec §22.4). */
export function WhatsAppButton({
  size = "md",
  short = false,
  variant = "tonal",
  className,
}: CtaProps & { variant?: "primary" | "tonal" }) {
  const t = useTranslations("cta");

  if (!siteConfig.whatsappUrl) {
    return <Pending label={t("whatsappSoon")} size={size} className={className} />;
  }

  return (
    <a
      href={siteConfig.whatsappUrl}
      target="_blank"
      rel="noopener noreferrer"
      className={buttonStyles({ variant, size, className })}
    >
      <MessageCircle aria-hidden className="size-[1.15em]" />
      {short ? t("whatsappShort") : t("whatsapp")}
      <span className="sr-only"> {t("newTab")}</span>
    </a>
  );
}
