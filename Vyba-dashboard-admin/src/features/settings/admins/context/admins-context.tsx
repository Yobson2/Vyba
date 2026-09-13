import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import type { Admin } from '../data/schema'

type AdminsDialogType = 'invite' | 'edit' | 'deactivate' | 'reset-password'

export interface TempPasswordResult {
  email: string
  temporaryPassword: string
}

interface AdminsContextType {
  open: AdminsDialogType | null
  setOpen: (str: AdminsDialogType | null) => void
  currentRow: Admin | null
  setCurrentRow: React.Dispatch<React.SetStateAction<Admin | null>>
  // Shown once right after an invite/reset mints a new password — never
  // retrievable again after this dialog closes.
  tempPasswordResult: TempPasswordResult | null
  setTempPasswordResult: React.Dispatch<
    React.SetStateAction<TempPasswordResult | null>
  >
}

const AdminsContext = React.createContext<AdminsContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function AdminsProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<AdminsDialogType>(null)
  const [currentRow, setCurrentRow] = useState<Admin | null>(null)
  const [tempPasswordResult, setTempPasswordResult] =
    useState<TempPasswordResult | null>(null)

  return (
    <AdminsContext
      value={{
        open,
        setOpen,
        currentRow,
        setCurrentRow,
        tempPasswordResult,
        setTempPasswordResult,
      }}
    >
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
