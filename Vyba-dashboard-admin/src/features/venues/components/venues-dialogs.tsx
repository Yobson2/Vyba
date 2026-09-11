import { useVenues } from '../context/venues-context'
import { VenuesActionDialog } from './venues-action-dialog'
import { VenuesDeleteDialog } from './venues-delete-dialog'
import { VenuesOwnerDialog } from './venues-owner-dialog'
import { VenuesUnbindOwnerDialog } from './venues-unbind-owner-dialog'

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

          <VenuesOwnerDialog
            key={`venue-owner-${currentRow.id}`}
            open={open === 'bind-owner'}
            onOpenChange={() => {
              setOpen('bind-owner')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />

          <VenuesUnbindOwnerDialog
            key={`venue-unbind-owner-${currentRow.id}`}
            open={open === 'unbind-owner'}
            onOpenChange={() => {
              setOpen('unbind-owner')
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
