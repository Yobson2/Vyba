import {
  IconBuilding,
  IconCalendarEvent,
  IconCurrencyNaira,
  IconFlag,
  IconTrendingUp,
  IconUsers,
} from '@tabler/icons-react'
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import { AnimatedContainer } from '@/components/motion/animated-container'
import {
  StaggerContainer,
  StaggerItem,
} from '@/components/motion/stagger-container'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { Search } from '@/components/search'
import { ThemeSwitch } from '@/components/theme-switch'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

const stats = [
  {
    title: 'Est. Revenue',
    value: '\u20A6 4.2M',
    change: '+18% from last month',
    icon: IconCurrencyNaira,
  },
  {
    title: 'Total Bookings',
    value: '1,247',
    change: '+89 this week',
    icon: IconCalendarEvent,
  },
  {
    title: 'Active Users',
    value: '2,350',
    change: '+180 new this month',
    icon: IconUsers,
  },
  {
    title: 'Active Venues',
    value: '42',
    change: '+3 new this month',
    icon: IconBuilding,
  },
  {
    title: 'Growth Rate',
    value: '+22.4%',
    change: '+4.1% from last month',
    icon: IconTrendingUp,
  },
  {
    title: 'Flagged Reviews',
    value: '23',
    change: 'Needs moderation',
    icon: IconFlag,
  },
]

const weeklyRevenue = [
  { day: 'Mon', revenue: 320000 },
  { day: 'Tue', revenue: 280000 },
  { day: 'Wed', revenue: 410000 },
  { day: 'Thu', revenue: 520000 },
  { day: 'Fri', revenue: 890000 },
  { day: 'Sat', revenue: 1120000 },
  { day: 'Sun', revenue: 650000 },
]

const bookingsByVenue = [
  { venue: 'Quilox', bookings: 48 },
  { venue: 'Atmosphere', bookings: 42 },
  { venue: 'Shiro', bookings: 35 },
  { venue: 'Hard Rock', bookings: 31 },
  { venue: 'Sky Lounge', bookings: 28 },
  { venue: 'Maquis', bookings: 22 },
]

const recentActivity = [
  {
    id: 1,
    actor: 'Adeola Johnson',
    action: 'Booked VIP booth at Club Quilox',
    time: '2 min ago',
  },
  {
    id: 2,
    actor: 'Tunde Bakare',
    action: 'Submitted new venue application: Sky Lounge',
    time: '8 min ago',
  },
  {
    id: 3,
    actor: 'Chioma Nwankwo',
    action: 'Left a 5-star review for Hard Rock Abidjan',
    time: '15 min ago',
  },
  {
    id: 4,
    actor: 'Venue: Atmosphere Rooftop',
    action: 'Created new promotion: Friday Happy Hour',
    time: '32 min ago',
  },
  {
    id: 5,
    actor: 'System',
    action: '12 pending bookings auto-expired',
    time: '1 hr ago',
  },
]

const formatNaira = (value: number) =>
  `\u20A6${(value / 1000).toFixed(0)}K`

export default function Dashboard() {
  return (
    <>
      <Header fixed>
        <Search />
        <div className='ml-auto flex items-center space-x-4'>
          <ThemeSwitch />
          <ProfileDropdown />
        </div>
      </Header>

      <Main>
        <div className='mb-2 flex items-center justify-between space-y-2'>
          <h1 className='text-2xl font-bold tracking-tight'>Dashboard</h1>
        </div>

        {/* Stats Grid */}
        <StaggerContainer className='grid gap-4 sm:grid-cols-2 lg:grid-cols-3'>
          {stats.map((stat) => (
            <StaggerItem key={stat.title}>
              <Card>
                <CardHeader className='flex flex-row items-center justify-between space-y-0 pb-2'>
                  <CardTitle className='text-sm font-medium'>
                    {stat.title}
                  </CardTitle>
                  <stat.icon className='text-muted-foreground h-4 w-4' />
                </CardHeader>
                <CardContent>
                  <div className='text-2xl font-bold'>{stat.value}</div>
                  <p className='text-muted-foreground text-xs'>{stat.change}</p>
                </CardContent>
              </Card>
            </StaggerItem>
          ))}
        </StaggerContainer>

        {/* Charts Row */}
        <AnimatedContainer variant='fadeSlideUp' delay={0.2}>
          <div className='mt-6 grid gap-4 lg:grid-cols-2'>
            {/* Weekly Revenue */}
            <Card>
              <CardHeader>
                <CardTitle>Weekly Revenue</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={240}>
                  <AreaChart data={weeklyRevenue}>
                    <defs>
                      <linearGradient
                        id='dashRevenueGrad'
                        x1='0'
                        y1='0'
                        x2='0'
                        y2='1'
                      >
                        <stop
                          offset='5%'
                          stopColor='#B0A3FF'
                          stopOpacity={0.3}
                        />
                        <stop
                          offset='95%'
                          stopColor='#B0A3FF'
                          stopOpacity={0}
                        />
                      </linearGradient>
                    </defs>
                    <CartesianGrid
                      strokeDasharray='3 3'
                      className='stroke-muted'
                    />
                    <XAxis
                      dataKey='day'
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <YAxis
                      tickFormatter={formatNaira}
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <Tooltip
                      formatter={(value: number) => [
                        `\u20A6${value.toLocaleString()}`,
                        'Revenue',
                      ]}
                      contentStyle={{
                        backgroundColor: 'hsl(var(--popover))',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'hsl(var(--popover-foreground))',
                      }}
                    />
                    <Area
                      type='monotone'
                      dataKey='revenue'
                      stroke='#B0A3FF'
                      strokeWidth={2}
                      fill='url(#dashRevenueGrad)'
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Top Venues by Bookings */}
            <Card>
              <CardHeader>
                <CardTitle>Top Venues This Week</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={240}>
                  <BarChart data={bookingsByVenue} layout='vertical'>
                    <CartesianGrid
                      strokeDasharray='3 3'
                      className='stroke-muted'
                      horizontal={false}
                    />
                    <XAxis
                      type='number'
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <YAxis
                      dataKey='venue'
                      type='category'
                      width={90}
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(var(--popover))',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'hsl(var(--popover-foreground))',
                      }}
                    />
                    <Bar dataKey='bookings' radius={[0, 4, 4, 0]}>
                      {bookingsByVenue.map((_, i) => (
                        <Cell
                          key={i}
                          fill={i === 0 ? '#B0A3FF' : '#69F6B8'}
                          fillOpacity={0.8}
                        />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          </div>
        </AnimatedContainer>

        {/* Recent Activity */}
        <AnimatedContainer variant='fadeSlideUp' delay={0.4}>
          <Card className='mt-4'>
            <CardHeader>
              <CardTitle>Recent Activity</CardTitle>
            </CardHeader>
            <CardContent>
              <div className='space-y-4'>
                {recentActivity.map((item) => (
                  <div
                    key={item.id}
                    className='flex items-center justify-between border-b pb-3 last:border-0 last:pb-0'
                  >
                    <div className='space-y-1'>
                      <p className='text-sm font-medium leading-none'>
                        {item.actor}
                      </p>
                      <p className='text-muted-foreground text-sm'>
                        {item.action}
                      </p>
                    </div>
                    <span className='text-muted-foreground shrink-0 text-sm'>
                      {item.time}
                    </span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </AnimatedContainer>
      </Main>
    </>
  )
}
