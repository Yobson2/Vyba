import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { EditorialItem } from '../data/schema'

type EditorialDialogType = 'add' | 'edit' | 'delete'

interface EditorialContextType {
  open: EditorialDialogType | null
  setOpen: (str: EditorialDialogType | null) => void
  currentRow: EditorialItem | null
  setCurrentRow: React.Dispatch<React.SetStateAction<EditorialItem | null>>
}

const EditorialContext = React.createContext<EditorialContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function EditorialProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<EditorialDialogType>(null)
  const [currentRow, setCurrentRow] = useState<EditorialItem | null>(null)

  return (
    <EditorialContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </EditorialContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useEditorial = () => {
  const context = React.useContext(EditorialContext)
  if (!context) {
    throw new Error('useEditorial has to be used within <EditorialContext>')
  }
  return context
}
