import { useCuration } from '../context/curation-context'
import { CurationDeleteDialog } from './curation-delete-dialog'

export function CurationDialogs() {
  const { open, setOpen, currentRow, setCurrentRow } = useCuration()
  return (
    <>
      {currentRow && (
        <CurationDeleteDialog
          key={`curation-delete-${currentRow.id}`}
          open={open === 'delete'}
          onOpenChange={() => {
            setOpen('delete')
            setTimeout(() => setCurrentRow(null), 500)
          }}
          currentRow={currentRow}
        />
      )}
    </>
  )
}
