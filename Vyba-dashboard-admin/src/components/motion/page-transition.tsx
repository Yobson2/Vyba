import { useRouterState } from '@tanstack/react-router'
import { AnimatePresence, motion } from 'framer-motion'
import { pageTransition } from '@/lib/motion'
import { useReducedMotion } from '@/hooks/use-reduced-motion'

interface PageTransitionProps {
  children: React.ReactNode
}

export function PageTransition({ children }: PageTransitionProps) {
  const routerState = useRouterState()
  const prefersReducedMotion = useReducedMotion()
  const locationKey = routerState.location.pathname

  if (prefersReducedMotion) {
    return <>{children}</>
  }

  return (
    <AnimatePresence mode='wait'>
      <motion.div
        key={locationKey}
        variants={pageTransition}
        initial='initial'
        animate='animate'
        exit='exit'
      >
        {children}
      </motion.div>
    </AnimatePresence>
  )
}
