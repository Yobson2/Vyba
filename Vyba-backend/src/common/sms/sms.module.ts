import { Global, Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FakeSmsProvider } from './fake-sms.provider';
import { SMS_PROVIDER } from './sms-provider.interface';

/**
 * No Africa-focused SMS vendor is integrated yet (tracked separately, out of
 * scope for the auth ticket — see docs/validation-mvp specs). `FakeSmsProvider`
 * is the only implementation today; a real provider slots in here behind the
 * same `SmsProvider` interface without touching auth logic.
 */
@Global()
@Module({
  providers: [
    FakeSmsProvider,
    {
      provide: SMS_PROVIDER,
      inject: [ConfigService, FakeSmsProvider],
      useFactory: (config: ConfigService, fake: FakeSmsProvider) => {
        const nodeEnv = config.get<string>('NODE_ENV', 'development');
        if (nodeEnv === 'production' || nodeEnv === 'staging') {
          new Logger('SmsModule').error(
            'No real SMS provider is configured; falling back to FakeSmsProvider. OTPs will not be delivered.',
          );
        }
        return fake;
      },
    },
  ],
  exports: [SMS_PROVIDER, FakeSmsProvider],
})
export class SmsModule {}
