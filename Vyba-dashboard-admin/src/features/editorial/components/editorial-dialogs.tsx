import { useEditorial } from '../context/editorial-context'
import { EditorialActionDialog } from './editorial-action-dialog'
import { EditorialDeleteDialog } from './editorial-delete-dialog'

export function EditorialDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = useEditorial()
  return (
    <>
      <EditorialActionDialog
        key='editorial-add'
        open={open === 'add'}
        onOpenChange={() => setOpen('add')}
      />

      {currentRow && (
        <>
          <EditorialActionDialog
            key={`editorial-edit-${currentRow.id}`}
            open={open === 'edit'}
            onOpenChange={() => {
              setOpen('edit')
              setTimeout(() => setCurrentRow(null), 500)
            }}
            currentRow={currentRow}
          />

          <EditorialDeleteDialog
            key={`editorial-delete-${currentRow.id}`}
            open={open === 'delete'}
            onOpenChange={() => {
              setOpen('delete')
              setTimeout(() => setCurrentRow(null), 500)
            }}
            currentRow={currentRow}
          />
        </>
      )}
    </>
  )
}
