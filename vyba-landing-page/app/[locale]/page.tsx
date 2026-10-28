import { setRequestLocale } from "next-intl/server";
import { HeroSection } from "@/app/features/hero/components/hero-section";
import { ProblemSection } from "@/app/features/problem/components/problem-section";
import { JourneySection } from "@/app/features/journey/components/journey-section";
import { GoingSection } from "@/app/features/going/components/going-section";
import { VenuesSection } from "@/app/features/venues/components/venues-section";
import { FaqSection } from "@/app/features/faq/components/faq-section";
import { FinalCtaSection } from "@/app/features/final-cta/components/final-cta-section";

type Props = {
  params: Promise<{ locale: string }>;
};

/**
 * Story order: what it is (hero) → why it matters (problem) → how it works
 * (one night, step by step) → the wedge and why to trust it (J'y vais) →
 * the supply side (venues) → objections (FAQ) → where + what to do next.
 */
export default async function HomePage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);

  return (
    <main id="main" tabIndex={-1} className="outline-none">
      <HeroSection />
      <ProblemSection />
      <JourneySection />
      <GoingSection />
      <VenuesSection />
      <FaqSection />
      <FinalCtaSection />
    </main>
  );
}
