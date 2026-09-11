import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';
import { REDIS_CLIENT } from '@common/redis/redis.provider';
import {
  OTP_CODE_TTL_SECONDS,
  OTP_IP_RATE_LIMIT_MAX,
  OTP_IP_RATE_LIMIT_WINDOW_SECONDS,
  OTP_PHONE_RATE_LIMIT_MAX,
  OTP_PHONE_RATE_LIMIT_WINDOW_SECONDS,
  OTP_RESEND_COOLDOWN_SECONDS,
} from './otp.constants';

/** Reads an env override for a tunable, falling back to the recommended default. Lets e2e tests use short windows instead of reaching into Redis. */
function tunable(
  config: ConfigService,
  envKey: string,
  fallback: number,
): number {
  const raw = config.get<string>(envKey);
  const parsed = raw === undefined ? NaN : Number(raw);
  return Number.isFinite(parsed) ? parsed : fallback;
}

const codeKey = (phone: string) => `otp:code:${phone}`;
const attemptsKey = (phone: string) => `otp:attempts:${phone}`;
const cooldownKey = (phone: string) => `otp:cooldown:${phone}`;
const phoneRateLimitKey = (phone: string) => `otp:ratelimit:phone:${phone}`;
const ipRateLimitKey = (ip: string) => `otp:ratelimit:ip:${ip}`;

/**
 * Redis-backed OTP bookkeeping: the code itself, wrong-attempt counter,
 * resend cooldown, and per-phone/per-IP request rate limits. Keeps every
 * raw Redis call (and key-naming convention) out of AuthService.
 */
@Injectable()
export class OtpStoreService {
  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly config: ConfigService,
  ) {}

  /** Stores a fresh code, resets the attempt counter, and starts the resend cooldown. Latest code wins. */
  async issueCode(phone: string, code: string): Promise<void> {
    const codeTtl = tunable(
      this.config,
      'OTP_CODE_TTL_SECONDS',
      OTP_CODE_TTL_SECONDS,
    );
    const cooldown = tunable(
      this.config,
      'OTP_RESEND_COOLDOWN_SECONDS',
      OTP_RESEND_COOLDOWN_SECONDS,
    );
    await Promise.all([
      this.redis.set(codeKey(phone), code, 'EX', codeTtl),
      this.redis.del(attemptsKey(phone)),
      this.redis.set(cooldownKey(phone), '1', 'EX', cooldown),
    ]);
  }

  async getCode(phone: string): Promise<string | null> {
    return this.redis.get(codeKey(phone));
  }

  async isCoolingDown(phone: string): Promise<boolean> {
    return (await this.redis.exists(cooldownKey(phone))) === 1;
  }

  async recordWrongAttempt(phone: string): Promise<number> {
    const codeTtl = tunable(
      this.config,
      'OTP_CODE_TTL_SECONDS',
      OTP_CODE_TTL_SECONDS,
    );
    const attempts = await this.redis.incr(attemptsKey(phone));
    if (attempts === 1) {
      await this.redis.expire(attemptsKey(phone), codeTtl);
    }
    return attempts;
  }

  /** Consumes (invalidates) the current code — on a successful verify or after too many wrong attempts. */
  async invalidateCode(phone: string): Promise<void> {
    await Promise.all([
      this.redis.del(codeKey(phone)),
      this.redis.del(attemptsKey(phone)),
    ]);
  }

  /** Returns true if the request is allowed, incrementing the window counter as a side effect. */
  async checkPhoneRateLimit(phone: string): Promise<boolean> {
    return this.checkRateLimit(
      phoneRateLimitKey(phone),
      tunable(
        this.config,
        'OTP_PHONE_RATE_LIMIT_MAX',
        OTP_PHONE_RATE_LIMIT_MAX,
      ),
      tunable(
        this.config,
        'OTP_PHONE_RATE_LIMIT_WINDOW_SECONDS',
        OTP_PHONE_RATE_LIMIT_WINDOW_SECONDS,
      ),
    );
  }

  async checkIpRateLimit(ip: string): Promise<boolean> {
    return this.checkRateLimit(
      ipRateLimitKey(ip),
      tunable(this.config, 'OTP_IP_RATE_LIMIT_MAX', OTP_IP_RATE_LIMIT_MAX),
      tunable(
        this.config,
        'OTP_IP_RATE_LIMIT_WINDOW_SECONDS',
        OTP_IP_RATE_LIMIT_WINDOW_SECONDS,
      ),
    );
  }

  private async checkRateLimit(
    key: string,
    max: number,
    windowSeconds: number,
  ): Promise<boolean> {
    const count = await this.redis.incr(key);
    if (count === 1) {
      await this.redis.expire(key, windowSeconds);
    }
    return count <= max;
  }
}
