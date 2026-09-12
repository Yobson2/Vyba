import { useOrganicVsAssistedQuery } from '../api/assist-api'

/**
 * The nudge panel (ticket 13): "cette semaine — X posts (Y assistés, Z
 * organiques)" — literal French copy per the ticket's own quoted text,
 * an exception to the rest of the (English) dashboard chrome since it's
 * the team's own shorthand for the organic-vs-assisted gate.
 */
export function VenueContentPanel({
  venueId,
}: {
  venueId: string | undefined
}) {
  const { data, isLoading } = useOrganicVsAssistedQuery(venueId)

  if (!venueId) return null

  return (
    <div className='bg-muted rounded-md p-4'>
      {isLoading || !data ? (
        <p className='text-muted-foreground text-sm'>Chargement...</p>
      ) : (
        <p className='text-sm'>
          <span className='font-medium'>
            cette semaine — {data.organic + data.assisted} posts
          </span>{' '}
          <span className='text-muted-foreground'>
            ({data.assisted} assisté{data.assisted > 1 ? 's' : ''},{' '}
            {data.organic} organique{data.organic > 1 ? 's' : ''})
          </span>
        </p>
      )}
    </div>
  )
}
