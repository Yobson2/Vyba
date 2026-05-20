import { ScrollArea } from '@/components/ui/scroll-area'

interface ContentSectionProps {
  title: string
  desc: string
  actions?: React.ReactNode
  children: React.JSX.Element
}

export default function ContentSection({
  title,
  desc,
  actions,
  children,
}: ContentSectionProps) {
  return (
    <div className='flex flex-1 flex-col'>
      <div className='flex items-start justify-between'>
        <div className='flex-none'>
          <h3 className='text-lg font-medium'>{title}</h3>
          <p className='text-muted-foreground text-sm'>{desc}</p>
        </div>
        {actions}
      </div>
      <div className='mb-6 flex-none' />
      <ScrollArea className='faded-bottom h-full w-full scroll-smooth pr-4 pb-28'>
        <div className='-mx-1 px-1.5 lg:max-w-2xl'>{children}</div>
      </ScrollArea>
    </div>
  )
}
