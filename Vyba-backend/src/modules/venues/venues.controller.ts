import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { VenuesService } from './venues.service';
import { CreateVenueDto } from './dto/create-venue.dto';
import { UpdateVenueDto } from './dto/update-venue.dto';
import { BindVenueOwnerDto } from './dto/bind-venue-owner.dto';
import { PaginationQueryDto } from '@common/dto/pagination.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { UserRole } from '@common/constants/roles.constant';

/**
 * Admin-only provisioning surface (ticket 05). Venues are created and
 * managed by the Vyba team, not self-serve — see ADR-0001. Client/public
 * read paths are a later unit.
 */
@ApiTags('Venues')
@ApiBearerAuth('JWT-auth')
@Controller('api/venues')
@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN)
export class VenuesController {
  constructor(private readonly venuesService: VenuesService) {}

  @Post()
  @ApiOperation({ summary: 'Create a venue (admin only)' })
  @ApiResponse({ status: 201, description: 'Venue created' })
  create(@Body() dto: CreateVenueDto) {
    return this.venuesService.create(dto);
  }

  @Get()
  @ApiOperation({ summary: 'List venues (paginated, admin only)' })
  @ApiResponse({ status: 200, description: 'Paginated venue list' })
  findAll(@Query() query: PaginationQueryDto) {
    return this.venuesService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get venue by ID (admin only)' })
  @ApiResponse({ status: 200, description: 'Venue found' })
  @ApiResponse({ status: 404, description: 'Venue not found' })
  findOne(@Param('id') id: string) {
    return this.venuesService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Update a venue, including its status (admin only)',
  })
  @ApiResponse({ status: 200, description: 'Venue updated' })
  update(@Param('id') id: string, @Body() dto: UpdateVenueDto) {
    return this.venuesService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Deactivate a venue (admin only)' })
  @ApiResponse({ status: 200, description: 'Venue deactivated' })
  remove(@Param('id') id: string) {
    return this.venuesService.remove(id);
  }

  @Post(':id/owner')
  @ApiOperation({
    summary: 'Provision (or re-bind) a VENUE_OWNER account for this venue',
  })
  @ApiResponse({ status: 200, description: 'Owner bound' })
  bindOwner(@Param('id') id: string, @Body() dto: BindVenueOwnerDto) {
    return this.venuesService.bindOwner(id, dto);
  }

  @Delete(':id/owner')
  @ApiOperation({ summary: 'Unbind the venue owner' })
  @ApiResponse({ status: 200, description: 'Owner unbound' })
  unbindOwner(@Param('id') id: string) {
    return this.venuesService.unbindOwner(id);
  }
}
