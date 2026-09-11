import { Injectable } from '@nestjs/common';
import { SmsDeliveryResult, SmsProvider } from './sms-provider.interface';

/**
 * Test/local-dev provider. Records the last code sent per phone instead of
 * dispatching anything, so a test (or a developer) can "receive" it without a
 * real SMS vendor. Never wired in staging/production — see sms.module.ts.
 */
@Injectable()
export class FakeSmsProvider implements SmsProvider {
  private readonly lastCodeByPhone = new Map<string, string>();

  send(phoneE164: string, message: string): Promise<SmsDeliveryResult> {
    const code = message.match(/\d{6}/)?.[0];
    if (code) {
      this.lastCodeByPhone.set(phoneE164, code);
    }
    return Promise.resolve({ accepted: true });
  }

  getLastCode(phoneE164: string): string | undefined {
    return this.lastCodeByPhone.get(phoneE164);
  }
}
