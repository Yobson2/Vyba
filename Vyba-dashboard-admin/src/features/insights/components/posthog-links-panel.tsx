import { IconExternalLink } from '@tabler/icons-react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { POSTHOG_LINKS } from '../data/definitions'

/** Outbound links for cohort/funnel detail — link out, never rebuild PostHog here (spec 18). */
export function PostHogLinksPanel() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Voir dans PostHog</CardTitle>
      </CardHeader>
      <CardContent className='flex flex-col gap-2'>
        {POSTHOG_LINKS.map((link) => (
          <a
            key={link.label}
            href={link.url}
            target='_blank'
            rel='noopener noreferrer'
            className='text-primary flex items-center gap-1.5 text-sm hover:underline'
          >
            <IconExternalLink size={14} />
            {link.label}
          </a>
        ))}
      </CardContent>
    </Card>
  )
}
