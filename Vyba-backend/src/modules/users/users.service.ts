import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
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
import { DEFAULT_ROLE } from '@common/constants/roles.constant';

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
    Object.assign(user, dto);
    return this.userRepository.save(user);
  }

  async remove(id: string): Promise<void> {
    const user = await this.findOne(id);
    user.isActive = false;
    await this.userRepository.save(user);
    this.logger.log(`User deactivated: ${id}`);
  }
}
