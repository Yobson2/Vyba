import { Link } from '@tanstack/react-router'
import {
  IconBuilding,
  IconCalendarEvent,
  IconChartBar,
  IconMessageCircle,
  IconShieldLock,
  IconSpeakerphone,
} from '@tabler/icons-react'
import { AnimatedContainer } from '@/components/motion/animated-container'
import {
  StaggerContainer,
  StaggerItem,
} from '@/components/motion/stagger-container'
import { Button } from '@/components/ui/button'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'

const features = [
  {
    icon: IconBuilding,
    title: 'Venue Management',
    description:
      'Manage venues, approve applications, and monitor listings across Lagos and beyond.',
  },
  {
    icon: IconCalendarEvent,
    title: 'Booking Operations',
    description:
      'Track bookings in real-time, manage confirmations, and handle cancellations.',
  },
  {
    icon: IconMessageCircle,
    title: 'Review Moderation',
    description:
      'Moderate user reviews, flag inappropriate content, and maintain platform quality.',
  },
  {
    icon: IconSpeakerphone,
    title: 'Promotions Control',
    description:
      'Approve and boost venue promotions, manage happy hours and event listings.',
  },
  {
    icon: IconChartBar,
    title: 'Analytics & Insights',
    description:
      'Revenue trends, booking patterns, user growth, and venue performance charts.',
  },
  {
    icon: IconShieldLock,
    title: 'Role-Based Access',
    description:
      'Granular permissions for super admins, managers, support agents, and viewers.',
  },
]

export default function LandingPage() {
  return (
    <div className='flex flex-col'>
      {/* Hero */}
      <section className='container mx-auto px-4 py-20 text-center sm:px-6 sm:py-32 lg:px-8'>
        <AnimatedContainer variant='fadeSlideUp'>
          <h1 className='text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl'>
            Lagos Nightlife,
            <br />
            <span className='text-primary'>Under Control</span>
          </h1>
          <p className='text-muted-foreground mx-auto mt-6 max-w-2xl text-lg'>
            The Vyba Admin Dashboard — manage venues, bookings, reviews, and
            promotions for Lagos&apos;s premier nightlife discovery platform.
          </p>
          <div className='mt-10 flex items-center justify-center gap-4'>
            <Button size='lg' asChild>
              <Link to='/sign-in'>Sign In</Link>
            </Button>
          </div>
        </AnimatedContainer>
      </section>

      {/* Features */}
      <section id='features' className='bg-muted/50 py-20 sm:py-24'>
        <div className='container mx-auto px-4 sm:px-6 lg:px-8'>
          <AnimatedContainer variant='fadeSlideUp' className='text-center'>
            <h2 className='text-3xl font-bold tracking-tight sm:text-4xl'>
              Everything You Need to Operate
            </h2>
            <p className='text-muted-foreground mx-auto mt-4 max-w-2xl text-lg'>
              Purpose-built tools for managing a nightlife marketplace at scale.
            </p>
          </AnimatedContainer>
          <StaggerContainer className='mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-3'>
            {features.map((feature) => (
              <StaggerItem key={feature.title}>
                <Card className='h-full'>
                  <CardHeader>
                    <feature.icon className='text-primary mb-2 h-8 w-8' />
                    <CardTitle className='text-lg'>{feature.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription className='text-sm'>
                      {feature.description}
                    </CardDescription>
                  </CardContent>
                </Card>
              </StaggerItem>
            ))}
          </StaggerContainer>
        </div>
      </section>

      {/* CTA */}
      <section className='py-20 sm:py-24'>
        <div className='container mx-auto px-4 text-center sm:px-6 lg:px-8'>
          <AnimatedContainer variant='fadeSlideUp'>
            <h2 className='text-3xl font-bold tracking-tight sm:text-4xl'>
              Ready to Manage the Night?
            </h2>
            <p className='text-muted-foreground mx-auto mt-4 max-w-xl text-lg'>
              Sign in to the Vyba Admin Dashboard and take control of your
              platform.
            </p>
            <div className='mt-8 flex items-center justify-center gap-4'>
              <Button size='lg' asChild>
                <Link to='/sign-in'>Sign In</Link>
              </Button>
            </div>
          </AnimatedContainer>
        </div>
      </section>
    </div>
  )
}
