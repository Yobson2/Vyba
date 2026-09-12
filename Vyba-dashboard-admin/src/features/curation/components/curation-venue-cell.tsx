import { useVenuesQuery } from '@/features/venues/api/venues-api'

/** Resolves a venue name from the already-cached venues list (assist-form uses the same query). */
export function CurationVenueCell({ venueId }: { venueId: string }) {
  const { data: venues } = useVenuesQuery()
  const venue = venues?.find((v) => v.id === venueId)
  return <span>{venue?.name ?? venueId.slice(0, 8)}</span>
}
