import { usePromotions } from '../context/promotions-context'
import { PromotionsActionDialog } from './promotions-action-dialog'
import { PromotionsDeleteDialog } from './promotions-delete-dialog'

export function PromotionsDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = usePromotions()
  return (
    <>
      {currentRow && (
        <>
          <PromotionsActionDialog
            key={`promotion-edit-${currentRow.id}`}
            open={open === 'edit'}
            onOpenChange={() => {
              setOpen('edit')
              setTimeout(() => {
                setCurrentRow(null)
              }, 500)
            }}
            currentRow={currentRow}
          />

          <PromotionsDeleteDialog
            key={`promotion-delete-${currentRow.id}`}
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
