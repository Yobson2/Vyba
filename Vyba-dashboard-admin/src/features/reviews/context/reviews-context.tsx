import React, { useState } from 'react'
import useDialogState from '@/hooks/use-dialog-state'
import { Review } from '../data/schema'

type ReviewsDialogType = 'edit' | 'delete'

interface ReviewsContextType {
  open: ReviewsDialogType | null
  setOpen: (str: ReviewsDialogType | null) => void
  currentRow: Review | null
  setCurrentRow: React.Dispatch<React.SetStateAction<Review | null>>
}

const ReviewsContext = React.createContext<ReviewsContextType | null>(null)

interface Props {
  children: React.ReactNode
}

export default function ReviewsProvider({ children }: Props) {
  const [open, setOpen] = useDialogState<ReviewsDialogType>(null)
  const [currentRow, setCurrentRow] = useState<Review | null>(null)

  return (
    <ReviewsContext value={{ open, setOpen, currentRow, setCurrentRow }}>
      {children}
    </ReviewsContext>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export const useReviews = () => {
  const reviewsContext = React.useContext(ReviewsContext)

  if (!reviewsContext) {
    throw new Error('useReviews has to be used within <ReviewsContext>')
  }

  return reviewsContext
}
