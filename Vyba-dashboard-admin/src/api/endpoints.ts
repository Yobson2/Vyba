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
} as const
