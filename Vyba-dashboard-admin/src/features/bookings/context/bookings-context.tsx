import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { Booking } from '../data/schema'

type BookingsDialogType = 'edit' | 'delete'

interface BookingsContextType {
  open: BookingsDialogType | null
  setOpen: (str: BookingsDialogType | null) => void
  currentRow: Booking | null
  setCurrentRow: React.Dispatch<React.SetStateAction<Booking | null>>
}

const BookingsContext = React.createContext<BookingsContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function BookingsProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<BookingsDialogType>(null)
  const [currentRow, setCurrentRow] = useState<Booking | null>(null)

  return (
    <BookingsContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </BookingsContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useBookings = () => {
  const bookingsContext = React.useContext(BookingsContext)

  if (!bookingsContext) {
    throw new Error('useBookings has to be used within <BookingsContext>')
  }

  return bookingsContext
}
