export interface ApiResponse<T> {
  data: T
  message: string
  success: boolean
}

/** Matches the backend's `PaginatedResponseDto` shape exactly (see Vyba-backend `common/dto/pagination.dto.ts`). */
export interface PaginatedResponse<T> {
  data: T[]
  meta: {
    page: number
    limit: number
    total: number
    totalPages: number
  }
}

export interface ApiError {
  message: string
  statusCode: number
  errors?: Record<string, string[]>
}
