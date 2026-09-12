import { Injectable } from '@nestjs/common';
import { FcmPayload, FcmSendResult, FcmSender } from './fcm-sender.interface';

export interface FakeFcmSend {
  tokens: string[];
  payload: FcmPayload;
}

/**
 * No real FCM project is wired for this environment yet (tracked
 * separately, out of scope for the notifications ticket — see
 * docs/validation-mvp specs). Records every send for e2e assertions; tests
 * can mark specific tokens undeliverable via `markInvalid` to exercise the
 * pruning/failed paths without a real Firebase project.
 */
@Injectable()
export class FakeFcmSender implements FcmSender {
  readonly sends: FakeFcmSend[] = [];
  private readonly invalidTokens = new Set<string>();

  markInvalid(token: string): void {
    this.invalidTokens.add(token);
  }

  async send(tokens: string[], payload: FcmPayload): Promise<FcmSendResult> {
    this.sends.push({ tokens, payload });
    const invalidTokens = tokens.filter((t) => this.invalidTokens.has(t));
    const deliveredTokens = tokens.filter((t) => !this.invalidTokens.has(t));
    return { deliveredTokens, invalidTokens };
  }
}
