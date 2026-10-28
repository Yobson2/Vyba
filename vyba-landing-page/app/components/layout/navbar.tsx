"use client";

import { useEffect, useRef, useState } from "react";
import { MenuIcon, XIcon } from "lucide-react";
import Image from "next/image";
import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { StoreButton } from "@/app/components/ui/cta-links";
import { navLinks, siteConfig } from "@/app/lib/constants";
import { cn } from "@/app/lib/utils";

/** Which in-page section is currently under the navbar. */
function useActiveSection(ids: string[]) {
  const [active, setActive] = useState<string | null>(null);

  useEffect(() => {
    const targets = ids
      .map((id) => document.getElementById(id))
      .filter((el): el is HTMLElement => el !== null);
    if (targets.length === 0) return;

    // Track every section so the highlight clears in the hero and between sections.
    const visible = new Set<string>();
    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) visible.add(entry.target.id);
          else visible.delete(entry.target.id);
        }
        setActive(ids.find((id) => visible.has(id)) ?? null);
      },
      { rootMargin: "-45% 0px -50% 0px" }
    );
    targets.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, [ids]);

  return active;
}

const sectionIds = navLinks.map((l) => l.href.split("#")[1] ?? "");

export function Navbar() {
  const t = useTranslations("nav");
  const [scrolled, setScrolled] = useState(false);
  const dialogRef = useRef<HTMLDialogElement>(null);
  const active = useActiveSection(sectionIds);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const openMenu = () => dialogRef.current?.showModal();
  const closeMenu = () => dialogRef.current?.close();

  return (
    <header
      className={cn(
        "sticky top-0 z-50 transition-[background-color,box-shadow] duration-300",
        scrolled ? "bg-surface/85 shadow-floating backdrop-blur-md" : "bg-transparent"
      )}
    >
      <nav
        aria-label={t("menuLabel")}
        className="container-page flex h-16 items-center justify-between gap-6 lg:h-18"
      >
        <Link href="/" aria-label={t("home")} className="flex items-center">
          <Image
            src={siteConfig.logo}
            width={96}
            height={30}
            alt=""
            priority
            className="h-7 w-auto"
          />
        </Link>

        <ul className="hidden items-center gap-1 lg:flex">
          {navLinks.map((link) => {
            const isActive = active === link.href.split("#")[1];
            return (
              <li key={link.href}>
                <Link
                  href={link.href}
                  aria-current={isActive ? "location" : undefined}
                  className={cn(
                    "rounded-full px-4 py-2 text-sm font-medium transition-colors",
                    isActive
                      ? "bg-surface-high text-on-surface"
                      : "text-on-surface-variant hover:text-on-surface"
                  )}
                >
                  {t(link.textKey)}
                </Link>
              </li>
            );
          })}
        </ul>

        <div className="flex items-center gap-2">
          <StoreButton size="sm" short className="hidden sm:inline-flex" />
          <button
            type="button"
            onClick={openMenu}
            aria-label={t("openMenu")}
            aria-haspopup="dialog"
            className="bg-surface-high flex size-11 items-center justify-center rounded-full transition active:scale-95 lg:hidden"
          >
            <MenuIcon aria-hidden className="size-5" />
          </button>
        </div>
      </nav>

      <dialog
        ref={dialogRef}
        aria-label={t("menuLabel")}
        onClick={(e) => e.target === dialogRef.current && closeMenu()}
        className="bg-surface-low text-on-surface backdrop:bg-surface/70 m-0 ml-auto h-dvh max-h-none w-full max-w-sm p-0 backdrop:backdrop-blur-sm open:animate-[menu-in_300ms_var(--ease-emphasized)] lg:hidden"
      >
        <div className="flex h-full flex-col px-6 pt-4 pb-8">
          <div className="flex justify-end">
            <button
              type="button"
              onClick={closeMenu}
              aria-label={t("closeMenu")}
              autoFocus
              className="bg-surface-high flex size-11 items-center justify-center rounded-full transition active:scale-95"
            >
              <XIcon aria-hidden className="size-5" />
            </button>
          </div>
          <ul className="mt-8 flex flex-col gap-1">
            {navLinks.map((link) => (
              <li key={link.href}>
                <Link
                  href={link.href}
                  onClick={closeMenu}
                  className="font-display hover:bg-surface-high block rounded-md px-3 py-3 text-2xl font-bold tracking-[-0.02em] transition-colors"
                >
                  {t(link.textKey)}
                </Link>
              </li>
            ))}
          </ul>
          <StoreButton size="lg" className="mt-auto w-full" />
        </div>
      </dialog>
    </header>
  );
}
