import { useReviews } from '../context/reviews-context'
import { ReviewsActionDialog } from './reviews-action-dialog'
import { ReviewsDeleteDialog } from './reviews-delete-dialog'

export function ReviewsDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = useReviews()
  return (
    <>
      {currentRow && (
        <>
          <ReviewsActionDialog
            key={`review-edit-${currentRow.id}`}
            open={open === 'edit'}
            onOpenChange={() => {
              setOpen('edit')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />

          <ReviewsDeleteDialog
            key={`review-delete-${currentRow.id}`}
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
