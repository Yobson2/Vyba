import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { GoingService } from './going.service';
import { MarkGoingDto } from './dto/mark-going.dto';
import { UpdateGoingDto } from './dto/update-going.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

@ApiTags('Going')
@ApiBearerAuth('JWT-auth')
@Controller('api/going')
export class GoingController {
  constructor(private readonly goingService: GoingService) {}

  @Post()
  @ApiOperation({ summary: '"J\'y vais" — mark tonight (idempotent re-mark)' })
  @ApiResponse({ status: 201, description: 'Marked' })
  @ApiResponse({ status: 403, description: "Can't mark your own venue" })
  mark(
    @Body() dto: MarkGoingDto,
    @GetUserId() userId: string,
    @Req() req: Request,
  ) {
    return this.goingService.mark(userId, req.ip ?? 'unknown', dto);
  }

  @Patch('venue/:venueId')
  @ApiOperation({ summary: "Edit tonight's mark (before midnight only)" })
  @ApiResponse({ status: 200, description: 'Updated' })
  update(
    @Param('venueId') venueId: string,
    @Body() dto: UpdateGoingDto,
    @GetUserId() userId: string,
  ) {
    return this.goingService.update(userId, venueId, dto);
  }

  @Delete('venue/:venueId')
  @ApiOperation({ summary: "Cancel tonight's mark (before midnight only)" })
  @ApiResponse({ status: 200, description: 'Canceled' })
  cancel(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.goingService.cancel(userId, venueId);
  }

  @Get('venue/:venueId/mine')
  @ApiOperation({ summary: 'My current mark for this venue tonight, if any' })
  @ApiResponse({ status: 200, description: 'The mark, or null' })
  getMine(@Param('venueId') venueId: string, @GetUserId() userId: string) {
    return this.goingService.getMine(userId, venueId);
  }

  @Get('venue/:venueId/owner-summary')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @ApiOperation({ summary: 'Going count + rough party sizes (owner only)' })
  @ApiResponse({ status: 200, description: 'Summary' })
  getOwnerSummary(
    @Param('venueId') venueId: string,
    @GetUserId() ownerId: string,
  ) {
    return this.goingService.getOwnerSummary(venueId, ownerId);
  }
}
