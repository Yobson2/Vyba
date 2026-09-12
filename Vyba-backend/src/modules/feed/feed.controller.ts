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
import { FeedItemsService } from './feed-items.service';
import {
  CreateEditorialDto,
  UpdateEditorialDto,
} from './dto/create-editorial.dto';
import { CreatePromoDto } from './dto/create-promo.dto';
import { FeedQueryDto } from './dto/feed-query.dto';
import { AdminFeedQueryDto } from './dto/admin-feed-query.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { Public } from '@common/decorators/public.decorator';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

@ApiTags('Feed')
@Controller('api/feed')
export class FeedController {
  constructor(private readonly feedItemsService: FeedItemsService) {}

  @Post('editorial')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Publish an editorial feed item (admin only)' })
  @ApiResponse({ status: 201, description: 'Editorial item created' })
  createEditorial(
    @Body() dto: CreateEditorialDto,
    @GetUserId() adminUserId: string,
  ) {
    return this.feedItemsService.createEditorial(dto, adminUserId);
  }

  @Patch('editorial/:id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Edit an editorial item (admin only)' })
  @ApiResponse({ status: 200, description: 'Editorial item updated' })
  updateEditorial(@Param('id') id: string, @Body() dto: UpdateEditorialDto) {
    return this.feedItemsService.updateEditorial(id, dto);
  }

  @Patch(':id/publish')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Publish a draft feed item (admin only)' })
  @ApiResponse({ status: 200, description: 'Item published' })
  publish(@Param('id') id: string) {
    return this.feedItemsService.publish(id);
  }

  @Post('venue/:venueId/promo/assist')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Create a promotion on behalf of a venue (admin assist path — origin = founder_assisted)',
  })
  @ApiResponse({ status: 201, description: 'Promo created' })
  createAssistedPromo(
    @Param('venueId') venueId: string,
    @GetUserId() adminUserId: string,
    @Body() dto: CreatePromoDto,
  ) {
    return this.feedItemsService.createAssistedPromo(venueId, adminUserId, dto);
  }

  @Get('admin')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Every feed item regardless of status (admin content lists — draft/expired included)',
  })
  @ApiResponse({ status: 200, description: 'Feed items' })
  listAdmin(@Query() query: AdminFeedQueryDto) {
    return this.feedItemsService.listAdmin(query);
  }

  @Post('venue/:venueId/promo')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Create a promotion for my venue (owner only, <10s flow)',
  })
  @ApiResponse({ status: 201, description: 'Promo created' })
  @ApiResponse({ status: 403, description: "Not this venue's owner" })
  createPromo(
    @Param('venueId') venueId: string,
    @GetUserId() ownerId: string,
    @Body() dto: CreatePromoDto,
  ) {
    return this.feedItemsService.createPromo(venueId, ownerId, dto);
  }

  @Get()
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'The ranked Zone 4 feed (any authenticated user, follow-aware)',
  })
  @ApiResponse({ status: 200, description: 'Ranked feed items' })
  getFeed(@Query() query: FeedQueryDto, @GetUserId() userId: string) {
    return this.feedItemsService.listFeed(userId, query.limit, query.offset);
  }

  @Get('public')
  @Public()
  @ApiOperation({
    summary:
      'The ranked Zone 4 feed, unauthenticated (QR-web hardening lands in ticket 12) — not follow-aware',
  })
  @ApiResponse({ status: 200, description: 'Ranked feed items' })
  getPublicFeed(@Query() query: FeedQueryDto) {
    return this.feedItemsService.listFeed(null, query.limit, query.offset);
  }

  @Patch(':id/hide')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Hide a feed item, reversibly (admin only)' })
  @ApiResponse({ status: 200, description: 'Item hidden' })
  hide(@Param('id') id: string) {
    return this.feedItemsService.hide(id);
  }

  @Patch(':id/unhide')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Unhide a previously hidden feed item (admin only)',
  })
  @ApiResponse({ status: 200, description: 'Item unhidden' })
  unhide(@Param('id') id: string) {
    return this.feedItemsService.unhide(id);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Hard-delete a feed item (admin only) — distinct from hide',
  })
  @ApiResponse({ status: 200, description: 'Item deleted' })
  remove(@Param('id') id: string) {
    return this.feedItemsService.remove(id);
  }
}
