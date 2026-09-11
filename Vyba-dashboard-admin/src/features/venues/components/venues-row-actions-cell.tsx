import { type CellContext } from '@tanstack/react-table'
import { DataTableRowActions, type RowAction } from '@/components/ui/data-table'
import { useVenues } from '../context/venues-context'
import { Venue } from '../data/schema'

export function VenuesRowActionsCell({ row }: CellContext<Venue, unknown>) {
  const venue = row.original
  const { setOpen, setCurrentRow } = useVenues()

  const actions: RowAction<Venue>[] = [
    {
      label: 'Edit',
      onSelect: () => {
        setCurrentRow(venue)
        setOpen('edit')
      },
    },
    {
      label: venue.owner ? 'Re-bind owner' : 'Créer / lier un propriétaire',
      onSelect: () => {
        setCurrentRow(venue)
        setOpen('bind-owner')
      },
    },
    ...(venue.owner
      ? [
          {
            label: 'Unbind owner',
            onSelect: () => {
              setCurrentRow(venue)
              setOpen('unbind-owner')
            },
          } satisfies RowAction<Venue>,
        ]
      : []),
    {
      label: 'Delete',
      destructive: true,
      separatorBefore: true,
      onSelect: () => {
        setCurrentRow(venue)
        setOpen('delete')
      },
    },
  ]

  return <DataTableRowActions row={row} actions={actions} />
}
