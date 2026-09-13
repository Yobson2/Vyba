import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import {
  PaginationQueryDto,
  PaginatedResponseDto,
} from '@common/dto/pagination.dto';
import {
  UserNotFoundError,
  UserAlreadyExistsError,
} from '@common/exceptions/user.exceptions';
import { DEFAULT_ROLE, UserRole } from '@common/constants/roles.constant';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  /**
   * Explicit creation path (e.g. Vyba team provisioning a venue-owner account
   * by phone number + role). Self-serve users come in via `findOrCreateByPhone`.
   */
  async create(dto: CreateUserDto): Promise<User> {
    const existing = await this.userRepository.findOne({
      where: { phone: dto.phone },
    });

    if (existing) {
      throw new UserAlreadyExistsError(dto.phone, 'phone');
    }

    const user = this.userRepository.create({
      phone: dto.phone,
      firstName: dto.firstName ?? null,
      lastName: dto.lastName ?? null,
      role: dto.role ?? DEFAULT_ROLE,
    });

    const saved = await this.userRepository.save(user);
    this.logger.log(`User created: ${saved.id}`);
    return saved;
  }

  /**
   * Identity resolution for the phone-OTP flow: the same E.164 number always
   * resolves to the same account (ADR-0003). Get-or-create, no linking logic.
   */
  async findOrCreateByPhone(phone: string): Promise<User> {
    const existing = await this.findByPhone(phone);
    if (existing) {
      return existing;
    }

    const user = this.userRepository.create({
      phone,
      role: DEFAULT_ROLE,
    });
    const saved = await this.userRepository.save(user);
    this.logger.log(`User created: ${saved.id}`);
    return saved;
  }

  async findByPhone(phone: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { phone } });
  }

  /** Batch lookup — used by `venues` to enrich a list with bound-owner summaries in one query. */
  async findByIds(ids: string[]): Promise<User[]> {
    if (ids.length === 0) return [];
    return this.userRepository.find({ where: { id: In(ids) } });
  }

  /**
   * Admin provisioning for a venue owner (ticket 05): get-or-create by
   * phone, upgrading an existing user to `VENUE_OWNER`. Supports re-binding
   * the same phone to a different venue without a duplicate-user error.
   */
  async provisionOwner(
    phone: string,
    firstName?: string,
    lastName?: string,
  ): Promise<User> {
    const existing = await this.findByPhone(phone);
    if (existing) {
      existing.role = UserRole.VENUE_OWNER;
      if (firstName !== undefined) existing.firstName = firstName;
      if (lastName !== undefined) existing.lastName = lastName;
      return this.userRepository.save(existing);
    }

    const user = this.userRepository.create({
      phone,
      firstName: firstName ?? null,
      lastName: lastName ?? null,
      role: UserRole.VENUE_OWNER,
    });
    const saved = await this.userRepository.save(user);
    this.logger.log(`User created: ${saved.id}`);
    return saved;
  }

  /**
   * Creates the `User` row backing an email+password ADMIN account (ADR-0003
   * exemption — see `AdminCredential`). `phone` is a synthetic placeholder,
   * never used for OTP: the column is NOT NULL/unique but admin login never
   * touches it.
   */
  async createAdminUser(
    placeholderPhone: string,
    firstName?: string,
    lastName?: string,
  ): Promise<User> {
    const user = this.userRepository.create({
      phone: placeholderPhone,
      firstName: firstName ?? null,
      lastName: lastName ?? null,
      role: UserRole.ADMIN,
      isActive: true,
      ageConfirmedAt: new Date(),
    });
    return this.userRepository.save(user);
  }

  /** Used to guard "don't deactivate the last admin" (see `AuthService.updateAdmin`). */
  async countActiveByRole(role: UserRole): Promise<number> {
    return this.userRepository.count({ where: { role, isActive: true } });
  }

  /** Records the 18+ confirmation on first verify (ADR-0003 / ticket 04). No-op once already set. */
  async confirmAge(id: string): Promise<User> {
    const user = await this.findOne(id);
    if (!user.ageConfirmedAt) {
      user.ageConfirmedAt = new Date();
      await this.userRepository.save(user);
    }
    return user;
  }

  /**
   * Writes the first-touch acquisition snapshot at signup (ticket 11 /
   * spec 07). Called once, from `attribution`'s
   * `recordSignupAttribution` — never overwritten afterwards, since raw
   * `LandingEvent`/`AcquisitionEvent` rows (not this snapshot) are the
   * record of truth for multi-touch history.
   */
  async writeAcquisitionSnapshot(
    id: string,
    snapshot: {
      acquisitionSource: string;
      acquisitionVenueId: string | null;
      acquisitionPromoterId: string | null;
      acquisitionCampaign: string | null;
      acquisitionZone: string | null;
      firstLandingAt: Date;
    },
  ): Promise<User> {
    const user = await this.findOne(id);
    user.acquisitionSource = snapshot.acquisitionSource;
    user.acquisitionVenueId = snapshot.acquisitionVenueId;
    user.acquisitionPromoterId = snapshot.acquisitionPromoterId;
    user.acquisitionCampaign = snapshot.acquisitionCampaign;
    user.acquisitionZone = snapshot.acquisitionZone;
    user.firstLandingAt = snapshot.firstLandingAt;
    user.acquisitionCapturedAt = new Date();
    return this.userRepository.save(user);
  }

  /**
   * `activeZone` — whether this user ENGAGES with Zone 4, never conflated
   * with `acquisitionZone` (where they came from). Set/refreshed on every
   * meaningful action involving a launch-area venue (ticket 11 / spec 07).
   */
  async updateActiveZone(id: string, zone: string): Promise<void> {
    await this.userRepository.update(id, {
      activeZone: zone,
      lastActiveAt: new Date(),
    });
  }

  /** Zone 4 WAU (ticket 11 / spec 07): active in the rolling window, engaging with Zone 4. */
  async countActiveInWindow(zone: string, sinceMs: number): Promise<number> {
    return this.userRepository
      .createQueryBuilder('user')
      .where('user.activeZone = :zone', { zone })
      .andWhere('user.lastActiveAt >= :since', { since: new Date(sinceMs) })
      .getCount();
  }

  /**
   * Raw signup/last-activity fields for the retention gate (ticket 18 /
   * spec 23) — PII-free (no phone), one row per user, cohorted and computed
   * in the caller since retention compares each user's own signup date to
   * their own last activity, not a shared calendar window.
   */
  async findRetentionCohortData(): Promise<
    {
      createdAt: Date;
      lastActiveAt: Date | null;
      acquisitionSource: string | null;
    }[]
  > {
    return this.userRepository.find({
      select: ['createdAt', 'lastActiveAt', 'acquisitionSource'],
    });
  }

  /**
   * The weekend-digest cohort (ticket 15 / spec 08): engaged with OR
   * acquired in the launch area — kept broad on purpose (the digest's own
   * preference filter narrows it further), unlike the stricter WAU query.
   */
  async findLaunchAreaCohortUserIds(zone: string): Promise<string[]> {
    const rows = await this.userRepository
      .createQueryBuilder('user')
      .where('user.activeZone = :zone', { zone })
      .orWhere('user.acquisitionZone = :zone', { zone })
      .select('user.id', 'id')
      .getRawMany<{ id: string }>();
    return rows.map((r) => r.id);
  }

  async findAll(
    query: PaginationQueryDto,
  ): Promise<PaginatedResponseDto<User>> {
    const page = query.page ?? 1;
    const limit = query.limit ?? 10;

    const [users, total] = await this.userRepository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });

    return new PaginatedResponseDto(users, total, page, limit);
  }

  async findOne(id: string): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new UserNotFoundError(id);
    }
    return user;
  }

  async update(id: string, dto: UpdateUserDto): Promise<User> {
    const user = await this.findOne(id);
    // Not `Object.assign(user, dto)`: with `useDefineForClassFields` (target
    // ES2022+), every declared-but-unsent optional field on `dto` is its own
    // property set to `undefined` — Object.assign would copy that over and
    // wipe the field on the in-memory `user` returned to the caller (the DB
    // write itself is unaffected, TypeORM skips `undefined` columns, but the
    // response lies about the current value until the next fetch).
    if (dto.firstName !== undefined) user.firstName = dto.firstName;
    if (dto.lastName !== undefined) user.lastName = dto.lastName;
    if (dto.isActive !== undefined) user.isActive = dto.isActive;
    return this.userRepository.save(user);
  }

  async remove(id: string): Promise<void> {
    const user = await this.findOne(id);
    user.isActive = false;
    await this.userRepository.save(user);
    this.logger.log(`User deactivated: ${id}`);
  }
}
