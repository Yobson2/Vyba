import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { CurationQueueItem } from '../data/schema'

type CurationDialogType = 'delete'

interface CurationContextType {
  open: CurationDialogType | null
  setOpen: (str: CurationDialogType | null) => void
  currentRow: CurationQueueItem | null
  setCurrentRow: React.Dispatch<React.SetStateAction<CurationQueueItem | null>>
}

const CurationContext = React.createContext<CurationContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function CurationProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<CurationDialogType>(null)
  const [currentRow, setCurrentRow] = useState<CurationQueueItem | null>(null)

  return (
    <CurationContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </CurationContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useCuration = () => {
  const context = React.useContext(CurationContext)
  if (!context) {
    throw new Error('useCuration has to be used within <CurationContext>')
  }
  return context
}
