import {
  IconBuilding,
  IconCalendarEvent,
  IconCurrencyNaira,
  IconStar,
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
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { Header } from '@/components/layout/header'
import { Main } from '@/components/layout/main'
import {
  StaggerContainer,
  StaggerItem,
} from '@/components/motion/stagger-container'
import { AnimatedContainer } from '@/components/motion/animated-container'
import { ProfileDropdown } from '@/components/profile-dropdown'
import { ThemeSwitch } from '@/components/theme-switch'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

// --- Mock Data ---

const kpiStats = [
  {
    title: 'Total Revenue',
    value: '\u20A6 12.4M',
    change: '+24.3% vs last quarter',
    icon: IconCurrencyNaira,
  },
  {
    title: 'Total Bookings',
    value: '4,821',
    change: '+18% vs last quarter',
    icon: IconCalendarEvent,
  },
  {
    title: 'Registered Users',
    value: '8,342',
    change: '+1,240 this quarter',
    icon: IconUsers,
  },
  {
    title: 'Active Venues',
    value: '42',
    change: '+6 new this quarter',
    icon: IconBuilding,
  },
  {
    title: 'Avg Venue Rating',
    value: '4.3',
    change: '+0.1 from last quarter',
    icon: IconStar,
  },
  {
    title: 'Growth Rate',
    value: '+22.4%',
    change: 'Quarter over quarter',
    icon: IconTrendingUp,
  },
]

const revenueByMonth = [
  { month: 'Jan', revenue: 820000 },
  { month: 'Feb', revenue: 950000 },
  { month: 'Mar', revenue: 1100000 },
  { month: 'Apr', revenue: 1350000 },
  { month: 'May', revenue: 1580000 },
  { month: 'Jun', revenue: 1420000 },
  { month: 'Jul', revenue: 1650000 },
  { month: 'Aug', revenue: 1890000 },
  { month: 'Sep', revenue: 2100000 },
  { month: 'Oct', revenue: 1950000 },
  { month: 'Nov', revenue: 2300000 },
  { month: 'Dec', revenue: 2800000 },
]

const bookingsByDay = [
  { day: 'Mon', bookings: 42 },
  { day: 'Tue', bookings: 38 },
  { day: 'Wed', bookings: 55 },
  { day: 'Thu', bookings: 67 },
  { day: 'Fri', bookings: 124 },
  { day: 'Sat', bookings: 156 },
  { day: 'Sun', bookings: 89 },
]

const userGrowth = [
  { month: 'Jan', users: 2100 },
  { month: 'Feb', users: 2450 },
  { month: 'Mar', users: 2980 },
  { month: 'Apr', users: 3520 },
  { month: 'May', users: 4210 },
  { month: 'Jun', users: 4890 },
  { month: 'Jul', users: 5340 },
  { month: 'Aug', users: 5980 },
  { month: 'Sep', users: 6570 },
  { month: 'Oct', users: 7120 },
  { month: 'Nov', users: 7780 },
  { month: 'Dec', users: 8342 },
]

const venueTypeDistribution = [
  { name: 'Club', value: 12, color: '#B0A3FF' },
  { name: 'Bar', value: 8, color: '#69F6B8' },
  { name: 'Lounge', value: 7, color: '#FFB148' },
  { name: 'Restaurant', value: 5, color: '#FF6E84' },
  { name: 'Rooftop', value: 4, color: '#64B5F6' },
  { name: 'Beach Club', value: 3, color: '#CE93D8' },
  { name: 'Maquis', value: 3, color: '#FFD54F' },
]

const topVenues = [
  { name: 'Club Quilox', bookings: 342, revenue: 4200000 },
  { name: 'Atmosphere Rooftop', bookings: 289, revenue: 3100000 },
  { name: 'Shiro Abidjan', bookings: 256, revenue: 2800000 },
  { name: 'Hard Rock Abidjan', bookings: 234, revenue: 2500000 },
  { name: 'Sky Lounge', bookings: 198, revenue: 1900000 },
]

const formatNaira = (value: number) =>
  `\u20A6${(value / 1000000).toFixed(1)}M`

const formatNairaFull = (value: number) =>
  `\u20A6${value.toLocaleString()}`

export default function Analytics() {
  return (
    <>
      <Header fixed>
        <div className='ml-auto flex items-center space-x-4'>
          <ThemeSwitch />
          <ProfileDropdown />
        </div>
      </Header>

      <Main>
        <div className='mb-2 flex items-center justify-between'>
          <div>
            <h1 className='text-2xl font-bold tracking-tight'>Analytics</h1>
            <p className='text-muted-foreground'>
              Platform performance and insights.
            </p>
          </div>
        </div>

        {/* KPI Cards */}
        <StaggerContainer className='grid gap-4 sm:grid-cols-2 lg:grid-cols-3'>
          {kpiStats.map((stat) => (
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
                  <p className='text-muted-foreground text-xs'>
                    {stat.change}
                  </p>
                </CardContent>
              </Card>
            </StaggerItem>
          ))}
        </StaggerContainer>

        {/* Charts Row 1: Revenue + Bookings by Day */}
        <AnimatedContainer variant='fadeSlideUp' delay={0.2}>
          <div className='mt-6 grid gap-4 lg:grid-cols-2'>
            {/* Revenue Trend */}
            <Card>
              <CardHeader>
                <CardTitle>Revenue Trend (2025)</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={300}>
                  <AreaChart data={revenueByMonth}>
                    <defs>
                      <linearGradient
                        id='revenueGradient'
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
                      dataKey='month'
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
                        formatNairaFull(value),
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
                      fill='url(#revenueGradient)'
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Bookings by Day of Week */}
            <Card>
              <CardHeader>
                <CardTitle>Bookings by Day</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={300}>
                  <BarChart data={bookingsByDay}>
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
                    <Bar dataKey='bookings' radius={[4, 4, 0, 0]}>
                      {bookingsByDay.map((entry) => (
                        <Cell
                          key={entry.day}
                          fill={
                            entry.day === 'Fri' || entry.day === 'Sat'
                              ? '#B0A3FF'
                              : '#69F6B8'
                          }
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

        {/* Charts Row 2: User Growth + Venue Distribution */}
        <AnimatedContainer variant='fadeSlideUp' delay={0.4}>
          <div className='mt-4 grid gap-4 lg:grid-cols-2'>
            {/* User Growth */}
            <Card>
              <CardHeader>
                <CardTitle>User Growth (2025)</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={300}>
                  <LineChart data={userGrowth}>
                    <CartesianGrid
                      strokeDasharray='3 3'
                      className='stroke-muted'
                    />
                    <XAxis
                      dataKey='month'
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <YAxis
                      className='text-xs'
                      tick={{ fill: 'currentColor' }}
                    />
                    <Tooltip
                      formatter={(value: number) => [
                        value.toLocaleString(),
                        'Users',
                      ]}
                      contentStyle={{
                        backgroundColor: 'hsl(var(--popover))',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'hsl(var(--popover-foreground))',
                      }}
                    />
                    <Line
                      type='monotone'
                      dataKey='users'
                      stroke='#69F6B8'
                      strokeWidth={2}
                      dot={{ fill: '#69F6B8', r: 3 }}
                      activeDot={{ r: 5 }}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Venue Type Distribution */}
            <Card>
              <CardHeader>
                <CardTitle>Venue Type Distribution</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width='100%' height={300}>
                  <PieChart>
                    <Pie
                      data={venueTypeDistribution}
                      cx='50%'
                      cy='50%'
                      innerRadius={60}
                      outerRadius={100}
                      paddingAngle={3}
                      dataKey='value'
                    >
                      {venueTypeDistribution.map((entry) => (
                        <Cell key={entry.name} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip
                      formatter={(value: number, name: string) => [
                        `${value} venues`,
                        name,
                      ]}
                      contentStyle={{
                        backgroundColor: 'hsl(var(--popover))',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'hsl(var(--popover-foreground))',
                      }}
                    />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          </div>
        </AnimatedContainer>

        {/* Top Venues Table */}
        <AnimatedContainer variant='fadeSlideUp' delay={0.6}>
          <Card className='mt-4'>
            <CardHeader>
              <CardTitle>Top Performing Venues</CardTitle>
            </CardHeader>
            <CardContent>
              <div className='space-y-4'>
                {topVenues.map((venue, i) => (
                  <div
                    key={venue.name}
                    className='flex items-center justify-between'
                  >
                    <div className='flex items-center gap-3'>
                      <span className='text-muted-foreground w-6 text-right text-sm font-medium'>
                        #{i + 1}
                      </span>
                      <span className='text-sm font-medium'>{venue.name}</span>
                    </div>
                    <div className='flex items-center gap-6'>
                      <span className='text-muted-foreground text-sm'>
                        {venue.bookings} bookings
                      </span>
                      <span className='text-sm font-medium'>
                        {formatNairaFull(venue.revenue)}
                      </span>
                    </div>
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
