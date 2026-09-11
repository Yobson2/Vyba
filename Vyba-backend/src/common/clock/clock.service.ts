import { Injectable } from '@nestjs/common';

/**
 * The current time, behind an injectable seam. Time-boundary logic (the
 * "J'y vais" midnight lock, ticket 08) reads `now()` through this instead of
 * `new Date()` directly, so e2e tests can `overrideProvider(ClockService)`
 * with a fixed clock instead of sleeping until a real boundary.
 */
@Injectable()
export class ClockService {
  now(): Date {
    return new Date();
  }
}
