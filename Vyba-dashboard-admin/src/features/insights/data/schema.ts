import { z } from 'zod'

export const venueTypeSchema = z.union([
  z.literal('CLUB'),
  z.literal('BAR'),
  z.literal('LOUNGE'),
  z.literal('MAQUIS'),
])

const recentFeedItemSchema = z.object({
  id: z.string(),
  type: z.string(),
  payload: z.record(z.string(), z.unknown()).nullable(),
  publishedAt: z.coerce.date(),
})

export const monitorVenueSchema = z.object({
  venueId: z.string(),
  venueName: z.string(),
  venueType: venueTypeSchema,
  isLive: z.boolean(),
  liveSince: z.coerce.date().nullable(),
  goingCount: z.number(),
  postCountToday: z.number(),
  recentFeedItems: z.array(recentFeedItemSchema),
  quiet: z.boolean(),
})
export type MonitorVenue = z.infer<typeof monitorVenueSchema>

export const monitorListSchema = z.array(monitorVenueSchema)

const retentionFigureSchema = z.object({
  cohortSize: z.number(),
  retained: z.number(),
  rate: z.number().nullable(),
})
export type RetentionFigure = z.infer<typeof retentionFigureSchema>

const retentionWindowsSchema = z.object({
  week1: retentionFigureSchema,
  week2: retentionFigureSchema,
  week4: retentionFigureSchema,
})
export type RetentionWindows = z.infer<typeof retentionWindowsSchema>

export const retentionReportSchema = z.object({
  overall: retentionWindowsSchema,
  bySource: z.record(z.string(), retentionWindowsSchema),
})
export type RetentionReport = z.infer<typeof retentionReportSchema>

export const organicPostingSchema = z.object({
  organicVenueCount: z.number(),
  totalVenueCount: z.number(),
})
export type OrganicPostingRollup = z.infer<typeof organicPostingSchema>

export const goingPerNightSchema = z.array(
  z.object({ date: z.string(), total: z.number() })
)
export type GoingPerNight = z.infer<typeof goingPerNightSchema>

export const contentActivitySchema = z.record(z.string(), z.number())
export type ContentActivity = z.infer<typeof contentActivitySchema>
