import { useBookings } from '../context/bookings-context'
import { BookingsActionDialog } from './bookings-action-dialog'
import { BookingsDeleteDialog } from './bookings-delete-dialog'

export function BookingsDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = useBookings()
  return (
    <>
      {currentRow && (
        <>
          <BookingsActionDialog
            key={`booking-edit-${currentRow.id}`}
            open={open === 'edit'}
            onOpenChange={() => {
              setOpen('edit')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />

          <BookingsDeleteDialog
            key={`booking-delete-${currentRow.id}`}
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
