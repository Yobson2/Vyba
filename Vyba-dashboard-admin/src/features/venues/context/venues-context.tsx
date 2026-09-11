import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { Venue } from '../data/schema'

type VenuesDialogType =
  | 'add'
  | 'edit'
  | 'delete'
  | 'bind-owner'
  | 'unbind-owner'

interface VenuesContextType {
  open: VenuesDialogType | null
  setOpen: (str: VenuesDialogType | null) => void
  currentRow: Venue | null
  setCurrentRow: React.Dispatch<React.SetStateAction<Venue | null>>
}

const VenuesContext = React.createContext<VenuesContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function VenuesProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<VenuesDialogType>(null)
  const [currentRow, setCurrentRow] = useState<Venue | null>(null)

  return (
    <VenuesContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </VenuesContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useVenues = () => {
  const venuesContext = React.useContext(VenuesContext)

  if (!venuesContext) {
    throw new Error('useVenues has to be used within <VenuesContext>')
  }

  return venuesContext
}
