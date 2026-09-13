import { Controller, Get, Query } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { VenuesService } from './venues.service';
import { SearchVenuesQueryDto } from './dto/search-venues-query.dto';

/**
 * Client-facing discovery surface (ADR-0005) — text search plus optional
 * geolocated "nearby" sorting, over every active/validated venue regardless
 * of location. Kept on its own path/controller (not `VenuesController`,
 * which is admin-only CRUD) so this never collides with `GET /api/venues/:id`.
 * Authenticated like `GET /api/feed` — no role restriction.
 */
@ApiTags('Venue discovery')
@ApiBearerAuth('JWT-auth')
@Controller('api/discover/venues')
export class VenueDiscoveryController {
  constructor(private readonly venuesService: VenuesService) {}

  @Get()
  @ApiOperation({
    summary: 'Search/browse venues (text query and/or nearby-by-location)',
  })
  @ApiResponse({ status: 200, description: 'Paginated venue list' })
  search(@Query() query: SearchVenuesQueryDto) {
    return this.venuesService.search(query);
  }
}
