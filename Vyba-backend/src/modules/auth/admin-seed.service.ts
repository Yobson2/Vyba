import { Injectable, Logger, OnApplicationBootstrap } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { randomBytes } from 'crypto';
import * as bcrypt from 'bcrypt';
import { AdminCredential } from './entities/admin-credential.entity';
import { UsersService } from '@modules/users/users.service';

const BCRYPT_ROUNDS = 12;

/**
 * Bootstraps the very first admin account so there's a default way in
 * before any admin exists to provision another one (ADR-0003's dashboard
 * email+password exemption). Opt-in via `SEED_ADMIN_EMAIL`/
 * `SEED_ADMIN_PASSWORD` — never hardcoded, and a no-op once an
 * `AdminCredential` for that email exists (so a changed password survives
 * every later restart).
 */
@Injectable()
export class AdminSeedService implements OnApplicationBootstrap {
  private readonly logger = new Logger(AdminSeedService.name);

  constructor(
    @InjectRepository(AdminCredential)
    private readonly adminCredentialRepository: Repository<AdminCredential>,
    private readonly usersService: UsersService,
    private readonly configService: ConfigService,
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    const email = this.configService.get<string>('SEED_ADMIN_EMAIL');
    const password = this.configService.get<string>('SEED_ADMIN_PASSWORD');
    if (!email || !password) return;

    const normalizedEmail = email.toLowerCase();
    const existing = await this.adminCredentialRepository.findOne({
      where: { email: normalizedEmail },
    });
    if (existing) return;

    const placeholderPhone = `sa_${randomBytes(6).toString('hex')}`;
    const user = await this.usersService.createAdminUser(placeholderPhone);
    const passwordHash = await bcrypt.hash(password, BCRYPT_ROUNDS);
    await this.adminCredentialRepository.save(
      this.adminCredentialRepository.create({
        userId: user.id,
        email: normalizedEmail,
        passwordHash,
      }),
    );

    this.logger.log(`Seed admin account created: ${normalizedEmail}`);
  }
}
