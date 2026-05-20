import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import type { Admin } from '../data/schema'

type AdminsDialogType = 'invite' | 'edit' | 'delete'

interface AdminsContextType {
  open: AdminsDialogType | null
  setOpen: (str: AdminsDialogType | null) => void
  currentRow: Admin | null
  setCurrentRow: React.Dispatch<React.SetStateAction<Admin | null>>
}

const AdminsContext = React.createContext<AdminsContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function AdminsProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<AdminsDialogType>(null)
  const [currentRow, setCurrentRow] = useState<Admin | null>(null)

  return (
    <AdminsContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </AdminsContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useAdmins = () => {
  const adminsContext = React.useContext(AdminsContext)

  if (!adminsContext) {
    throw new Error('useAdmins has to be used within <AdminsContext>')
  }

  return adminsContext
}
