import {
  Controller,
  Post,
  Get,
  Patch,
  Delete,
  Param,
  Query,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
} from '@nestjs/swagger';
import { MediaService } from './media.service';
import { UploadVenueNightPhotoDto } from './dto/upload-venue-night-photo.dto';
import { AdminMediaQueryDto } from './dto/admin-media-query.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { GetUser, GetUserId } from '@common/decorators/get-user.decorator';
import { UserRole } from '@common/constants/roles.constant';

const MAX_UPLOAD_BYTES = 8 * 1024 * 1024;

@ApiTags('Media')
@Controller('api/media')
export class MediaController {
  constructor(private readonly mediaService: MediaService) {}

  @Post('venue-night-photo')
  @UseGuards(RolesGuard)
  @Roles(UserRole.CLIENT)
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES } }),
  )
  @ApiBearerAuth('JWT-auth')
  @ApiConsumes('multipart/form-data')
  @ApiOperation({
    summary:
      'Add a photo to a venue for tonight (client only) — visible on the night view, not the main feed',
  })
  @ApiResponse({ status: 201, description: 'Photo uploaded' })
  uploadVenueNightPhoto(
    @Body() dto: UploadVenueNightPhotoDto,
    @UploadedFile() file: Express.Multer.File | undefined,
    @GetUser() user: { userId: string; role: UserRole },
  ) {
    if (!file) throw new BadRequestException('No file uploaded');
    return this.mediaService.uploadVenueNightPhoto(
      user.userId,
      user.role,
      dto.venueId,
      file,
    );
  }

  @Post('owner/venue-photo')
  @UseGuards(RolesGuard)
  @Roles(UserRole.VENUE_OWNER)
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES } }),
  )
  @ApiBearerAuth('JWT-auth')
  @ApiConsumes('multipart/form-data')
  @ApiOperation({
    summary: 'Upload a venue profile photo (owner only) — visible immediately',
  })
  @ApiResponse({ status: 201, description: 'Photo uploaded' })
  uploadVenueProfilePhoto(
    @UploadedFile() file: Express.Multer.File | undefined,
    @GetUserId() ownerId: string,
  ) {
    if (!file) throw new BadRequestException('No file uploaded');
    return this.mediaService.uploadVenueProfilePhoto(ownerId, file);
  }

  @Get('venue/:venueId/night-photos')
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      "Tonight's active user photos for a venue (any authenticated user) — the venue/night view seam",
  })
  @ApiResponse({ status: 200, description: 'Active night photos' })
  listNightPhotos(@Param('venueId') venueId: string) {
    return this.mediaService.listActiveNightPhotos(venueId);
  }

  @Get('admin')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary:
      'Curation queue — user-submitted night photos by status/venue/date',
  })
  @ApiResponse({ status: 200, description: 'Curation queue items' })
  listAdmin(@Query() query: AdminMediaQueryDto) {
    return this.mediaService.listAdmin(query);
  }

  @Patch(':id/promote')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Promote a curated user photo into the main feed (admin only)',
  })
  @ApiResponse({ status: 200, description: 'Photo promoted' })
  promote(@Param('id') id: string) {
    return this.mediaService.promote(id);
  }

  @Patch(':id/hide')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Hide a photo, reversibly (admin only)' })
  @ApiResponse({ status: 200, description: 'Photo hidden' })
  hide(@Param('id') id: string) {
    return this.mediaService.hide(id);
  }

  @Delete('admin/:id')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Hard-delete a photo (admin only)' })
  @ApiResponse({ status: 200, description: 'Photo deleted' })
  removeAdmin(@Param('id') id: string) {
    return this.mediaService.remove(id);
  }

  @Delete(':id')
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Delete my own uploaded photo (any authenticated uploader)',
  })
  @ApiResponse({ status: 200, description: 'Photo deleted' })
  @ApiResponse({ status: 403, description: 'Not the uploader' })
  removeOwn(@Param('id') id: string, @GetUserId() userId: string) {
    return this.mediaService.removeOwn(id, userId);
  }
}
