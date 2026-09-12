import { Controller, Get, Post, Delete, Param } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { FollowsService } from './follows.service';
import { GetUserId } from '@common/decorators/get-user.decorator';

@ApiTags('Follows')
@ApiBearerAuth('JWT-auth')
@Controller('api/follows')
export class FollowsController {
  constructor(private readonly followsService: FollowsService) {}

  @Post('venue/:venueId')
  @ApiOperation({ summary: 'Follow a venue (idempotent)' })
  @ApiResponse({ status: 201, description: 'Followed' })
  follow(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.followsService.follow(userId, venueId);
  }

  @Delete('venue/:venueId')
  @ApiOperation({ summary: 'Unfollow a venue (idempotent)' })
  @ApiResponse({ status: 200, description: 'Unfollowed' })
  unfollow(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.followsService.unfollow(userId, venueId);
  }

  @Get('venue/:venueId/mine')
  @ApiOperation({ summary: 'Do I follow this venue?' })
  @ApiResponse({ status: 200, description: 'isFollowing' })
  async isFollowing(
    @Param('venueId') venueId: string,
    @GetUserId() userId: string,
  ) {
    return {
      isFollowing: await this.followsService.isFollowing(userId, venueId),
    };
  }

  @Get('mine')
  @ApiOperation({ summary: '"Mes lieux suivis" — my followed venues' })
  @ApiResponse({ status: 200, description: 'Followed venues' })
  getMine(@GetUserId() userId: string) {
    return this.followsService.getMyFollowedVenues(userId);
  }
}
