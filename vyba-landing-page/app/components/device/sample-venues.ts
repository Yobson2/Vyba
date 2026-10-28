/**
 * Sample venues for the product previews. Illustrative only — every preview
 * that uses them carries the "lieux et contenus d'exemple" caption.
 * Never present these as real partners.
 */
export interface SampleVenue {
  name: string;
  initials: string;
  kind: string;
  area: string;
}

export const sampleVenues = {
  comptoir: { name: "Le Comptoir", initials: "LC", kind: "Bar", area: "Zone 4" },
  onyx: { name: "Onyx Lounge", initials: "OX", kind: "Lounge", area: "Zone 4" },
  tantie: { name: "Chez Tantie", initials: "CT", kind: "Maquis", area: "Marcory" },
  bloc: { name: "Le Bloc", initials: "LB", kind: "Boîte", area: "Zone 4" },
  terrasse: { name: "La Terrasse", initials: "LT", kind: "Bar", area: "Marcory" },
} satisfies Record<string, SampleVenue>;
