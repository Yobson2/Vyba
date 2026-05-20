import { useVenues } from '../context/venues-context'
import { VenuesActionDialog } from './venues-action-dialog'
import { VenuesDeleteDialog } from './venues-delete-dialog'

export function VenuesDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = useVenues()
  return (
    <>
      <VenuesActionDialog
        key='venue-add'
        open={open === 'add'}
        onOpenChange={() => setOpen('add')}
      />

      {currentRow && (
        <>
          <VenuesActionDialog
            key={`venue-edit-${currentRow.id}`}
            open={open === 'edit'}
            onOpenChange={() => {
              setOpen('edit')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />

          <VenuesDeleteDialog
            key={`venue-delete-${currentRow.id}`}
            open={open === 'delete'}
            onOpenChange={() => {
              setOpen('delete')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />
        </>
      )}
    </>
  )
}
