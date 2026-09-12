import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsWhere, In, Repository } from 'typeorm';
import sharp from 'sharp';
import {
  MediaAsset,
  MediaAssetStatus,
  MediaContextType,
} from './entities/media-asset.entity';
import { AdminMediaQueryDto } from './dto/admin-media-query.dto';
import {
  STORAGE_PROVIDER,
  StorageProvider,
} from '@common/storage/storage-provider.interface';
import { FileValidationHelper } from '@common/storage/file-validation.helper';
import {
  MediaAssetNotFoundError,
  MediaForbiddenError,
} from '@common/exceptions/media.exceptions';
import { UserRole } from '@common/constants/roles.constant';
import { VenuesService } from '@modules/venues/venues.service';
import { VenueNightsService } from '@modules/venue-nights/venue-nights.service';
import { FeedItemsService } from '@modules/feed/feed-items.service';

export interface UploadedFile {
  buffer: Buffer;
  mimetype: string;
  originalname: string;
}

export interface CurationQueueItem {
  id: string;
  url: string;
  thumbnailUrl: string;
  venueId: string;
  venueNightId: string | null;
  venueNightDate: string | null;
  uploadedByUserId: string;
  status: MediaAssetStatus;
  feedPromoted: boolean;
  createdAt: Date;
}

/** jpeg/png/webp only, 8 MB cap (spec 06) — narrower than the shared storage default. */
const IMAGE_VALIDATION = {
  customMimeTypes: ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'],
  maxSize: 8 * 1024 * 1024,
};

const DISPLAY_MAX_WIDTH = 1600;
const THUMBNAIL_MAX_WIDTH = 320;

@Injectable()
export class MediaService {
  constructor(
    @InjectRepository(MediaAsset)
    private readonly mediaAssetRepository: Repository<MediaAsset>,
    @Inject(STORAGE_PROVIDER)
    private readonly storage: StorageProvider,
    private readonly venuesService: VenuesService,
    private readonly venueNightsService: VenueNightsService,
    private readonly feedItemsService: FeedItemsService,
  ) {}

  /** Client "ajouter une photo" (ticket 14): visible on the night view immediately, not in the feed. */
  async uploadVenueNightPhoto(
    userId: string,
    role: UserRole,
    venueId: string,
    file: UploadedFile,
  ): Promise<MediaAsset> {
    await this.venuesService.findActiveOrThrow(venueId);
    const night = await this.venueNightsService.getOrCreateTonight(venueId);

    const { originalKey, displayKey, thumbnailKey } = await this.storeImage(
      'venue-nights',
      file,
    );

    const asset = this.mediaAssetRepository.create({
      storageKey: originalKey.key,
      url: originalKey.url,
      displayUrl: displayKey.url,
      thumbnailUrl: thumbnailKey.url,
      uploadedByUserId: userId,
      uploadedByRole: role,
      contextType: MediaContextType.VENUE_NIGHT_USER,
      venueId,
      venueNightId: night.id,
      feedItemId: null,
      status: MediaAssetStatus.ACTIVE,
      feedPromoted: false,
    });
    return this.mediaAssetRepository.save(asset);
  }

  /** Venue-owner profile photo (ticket 14): active/usable immediately, appended to `Venue.photos`. */
  async uploadVenueProfilePhoto(
    ownerId: string,
    file: UploadedFile,
  ): Promise<MediaAsset> {
    const venue = await this.venuesService.findMine(ownerId);

    const { originalKey, displayKey, thumbnailKey } = await this.storeImage(
      'venue-profiles',
      file,
    );

    const asset = this.mediaAssetRepository.create({
      storageKey: originalKey.key,
      url: originalKey.url,
      displayUrl: displayKey.url,
      thumbnailUrl: thumbnailKey.url,
      uploadedByUserId: ownerId,
      uploadedByRole: UserRole.VENUE_OWNER,
      contextType: MediaContextType.VENUE_PROFILE,
      venueId: venue.id,
      venueNightId: null,
      feedItemId: null,
      status: MediaAssetStatus.ACTIVE,
      feedPromoted: false,
    });
    const saved = await this.mediaAssetRepository.save(asset);
    await this.venuesService.appendPhoto(venue.id, saved.url);
    return saved;
  }

  /**
   * Tonight's active user photos for a venue (spec 06 visibility rule): the
   * venue/night detail view's seam onto `media` — `venue-nights` never
   * depends on this module (would be circular), so the client fetches this
   * alongside the venue detail read instead of it being embedded there.
   */
  async listActiveNightPhotos(
    venueId: string,
  ): Promise<Array<{ id: string; url: string; thumbnailUrl: string }>> {
    const nightId = await this.venueNightsService.findTonightId(venueId);
    if (!nightId) return [];

    const assets = await this.mediaAssetRepository.find({
      where: {
        venueId,
        venueNightId: nightId,
        contextType: MediaContextType.VENUE_NIGHT_USER,
        status: MediaAssetStatus.ACTIVE,
      },
      order: { createdAt: 'DESC' },
    });
    return assets.map((a) => ({
      id: a.id,
      url: a.url,
      thumbnailUrl: a.thumbnailUrl,
    }));
  }

  /**
   * Curation queue (ticket 14, ADMIN-only): `venue_night_user` assets by
   * status/venue/date, newest first.
   */
  async listAdmin(query: AdminMediaQueryDto): Promise<CurationQueueItem[]> {
    const where: FindOptionsWhere<MediaAsset> = {
      contextType: MediaContextType.VENUE_NIGHT_USER,
    };
    if (query.status) where.status = query.status;
    if (query.venueId) where.venueId = query.venueId;
    if (query.date) {
      const ids = await this.venueNightsService.findIdsByDate(query.date);
      where.venueNightId = In(ids.length > 0 ? ids : ['(none)']);
    }

    const assets = await this.mediaAssetRepository.find({
      where,
      order: { createdAt: 'DESC' },
    });

    const nightIds = [
      ...new Set(
        assets
          .map((a) => a.venueNightId)
          .filter((id): id is string => id !== null),
      ),
    ];
    const nights = await this.venueNightsService.findByIds(nightIds);
    const dateByNightId = new Map(nights.map((n) => [n.id, n.date]));

    return assets.map((a) => ({
      id: a.id,
      url: a.url,
      thumbnailUrl: a.thumbnailUrl,
      venueId: a.venueId!,
      venueNightId: a.venueNightId,
      venueNightDate: a.venueNightId
        ? (dateByNightId.get(a.venueNightId) ?? null)
        : null,
      uploadedByUserId: a.uploadedByUserId,
      status: a.status,
      feedPromoted: a.feedPromoted,
      createdAt: a.createdAt,
    }));
  }

  /** ADMIN promotes a curated user photo into the main feed (spec 06 — `feed` decides `origin`). */
  async promote(id: string): Promise<MediaAsset> {
    const asset = await this.findOrThrow(id);
    if (asset.feedPromoted || !asset.venueNightId) {
      return asset;
    }

    const night = await this.venueNightsService.findNightOrThrow(
      asset.venueNightId,
    );
    const feedItem = await this.feedItemsService.promoteMediaAsset({
      venueId: asset.venueId!,
      venueNightId: asset.venueNightId,
      venueNightDate: night.date,
      uploadedByUserId: asset.uploadedByUserId,
      mediaAssetId: asset.id,
      imageUrl: asset.url,
    });

    asset.feedPromoted = true;
    asset.feedItemId = feedItem.id;
    return this.mediaAssetRepository.save(asset);
  }

  /** ADMIN hide (reversible) — also hides the promoted feed item, if any. */
  async hide(id: string): Promise<MediaAsset> {
    const asset = await this.findOrThrow(id);
    asset.status = MediaAssetStatus.HIDDEN;
    if (asset.feedItemId) {
      await this.feedItemsService.hide(asset.feedItemId);
    }
    return this.mediaAssetRepository.save(asset);
  }

  /** ADMIN hard-delete — distinct from `hide`. */
  async remove(id: string): Promise<void> {
    const asset = await this.findOrThrow(id);
    await this.destroy(asset);
  }

  /** The uploader deletes their own asset (spec 06) — any other caller is forbidden. */
  async removeOwn(id: string, userId: string): Promise<void> {
    const asset = await this.findOrThrow(id);
    if (asset.uploadedByUserId !== userId) {
      throw new MediaForbiddenError(id);
    }
    await this.destroy(asset);
  }

  private async destroy(asset: MediaAsset): Promise<void> {
    if (asset.feedItemId) {
      await this.feedItemsService.remove(asset.feedItemId);
    }
    await this.storage.deleteFile(asset.storageKey);
    asset.status = MediaAssetStatus.DELETED;
    await this.mediaAssetRepository.save(asset);
  }

  private async storeImage(folder: string, file: UploadedFile) {
    FileValidationHelper.validateFile(
      file.buffer,
      file.mimetype,
      file.originalname,
      IMAGE_VALIDATION,
    );

    const baseName = this.storage.generateFileName(file.originalname);
    const display = await sharp(file.buffer)
      .resize({ width: DISPLAY_MAX_WIDTH, withoutEnlargement: true })
      .toBuffer();
    const thumbnail = await sharp(file.buffer)
      .resize({ width: THUMBNAIL_MAX_WIDTH, withoutEnlargement: true })
      .toBuffer();

    const [originalKey, displayKey, thumbnailKey] = await Promise.all([
      this.storage.uploadFile(folder, `original-${baseName}`, {
        buffer: file.buffer,
        mimetype: file.mimetype,
        originalname: file.originalname,
        validationOptions: { allowAllTypes: true },
      }),
      this.storage.uploadFile(folder, `display-${baseName}`, {
        buffer: display,
        mimetype: file.mimetype,
        originalname: file.originalname,
        validationOptions: { allowAllTypes: true },
      }),
      this.storage.uploadFile(folder, `thumb-${baseName}`, {
        buffer: thumbnail,
        mimetype: file.mimetype,
        originalname: file.originalname,
        validationOptions: { allowAllTypes: true },
      }),
    ]);

    return { originalKey, displayKey, thumbnailKey };
  }

  private async findOrThrow(id: string): Promise<MediaAsset> {
    const asset = await this.mediaAssetRepository.findOne({ where: { id } });
    if (!asset) {
      throw new MediaAssetNotFoundError(id);
    }
    return asset;
  }
}
