import {
  Controller,
  Get,
  Post,
  Patch,
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
import { CreateEditorialDto } from './dto/create-editorial.dto';
import { CreatePromoDto } from './dto/create-promo.dto';
import { FeedQueryDto } from './dto/feed-query.dto';
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
  @ApiOperation({ summary: 'The ranked Zone 4 feed (any authenticated user)' })
  @ApiResponse({ status: 200, description: 'Ranked feed items' })
  getFeed(@Query() query: FeedQueryDto) {
    return this.feedItemsService.listFeed(query.limit, query.offset);
  }

  @Get('public')
  @Public()
  @ApiOperation({
    summary:
      'The ranked Zone 4 feed, unauthenticated (QR-web hardening lands in ticket 12)',
  })
  @ApiResponse({ status: 200, description: 'Ranked feed items' })
  getPublicFeed(@Query() query: FeedQueryDto) {
    return this.feedItemsService.listFeed(query.limit, query.offset);
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
}
