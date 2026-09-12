export const ENDPOINTS = {
  AUTH: {
    LOGIN: '/auth/login',
    REGISTER: '/auth/register',
    LOGOUT: '/auth/logout',
    REFRESH: '/auth/refresh',
  },
  USERS: {
    LIST: '/users',
    DETAIL: (id: string) => `/users/${id}`,
  },
  VENUES: {
    LIST: '/venues',
    DETAIL: (id: string) => `/venues/${id}`,
    OWNER: (id: string) => `/venues/${id}/owner`,
  },
  FEED: {
    ADMIN_LIST: '/feed/admin',
    EDITORIAL: '/feed/editorial',
    EDITORIAL_DETAIL: (id: string) => `/feed/editorial/${id}`,
    PUBLISH: (id: string) => `/feed/${id}/publish`,
    HIDE: (id: string) => `/feed/${id}/hide`,
    UNHIDE: (id: string) => `/feed/${id}/unhide`,
    DETAIL: (id: string) => `/feed/${id}`,
    ASSIST_PROMO: (venueId: string) => `/feed/venue/${venueId}/promo/assist`,
  },
  METRICS: {
    ORGANIC_VS_ASSISTED: (venueId: string) =>
      `/metrics/venue/${venueId}/organic-vs-assisted`,
    ZONE4_WAU: '/metrics/zone4-wau',
    RETENTION: '/metrics/retention',
    ORGANIC_POSTING: '/metrics/organic-posting',
    GOING_PER_NIGHT: '/metrics/going-per-night',
    ACTIVE_VENUES: '/metrics/active-venues',
    CONTENT_ACTIVITY: '/metrics/content-activity',
    MONITOR_TONIGHT: '/metrics/monitor/tonight',
  },
  MEDIA: {
    ADMIN_LIST: '/media/admin',
    PROMOTE: (id: string) => `/media/${id}/promote`,
    HIDE: (id: string) => `/media/${id}/hide`,
    DELETE: (id: string) => `/media/admin/${id}`,
  },
} as const
