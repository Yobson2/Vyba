import { Logger, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BullModule } from '@nestjs/bullmq';
import { ConfigService } from '@nestjs/config';
import { DeviceToken } from './entities/device-token.entity';
import { NotificationPreference } from './entities/notification-preference.entity';
import { SentNotification } from './entities/sent-notification.entity';
import { VenueBroadcastOptIn } from './entities/venue-broadcast-opt-in.entity';
import { NotificationsService } from './notifications.service';
import { NotificationsController } from './notifications.controller';
import { NotificationsProcessor } from './notifications.processor';
import { NotificationsScheduler } from './notifications.scheduler';
import { NOTIFICATIONS_QUEUE } from './notifications.constants';
import { FakeFcmSender } from './fcm/fake-fcm.sender';
import { FirebaseFcmSender } from './fcm/firebase-fcm.sender';
import { FCM_SENDER } from './fcm/fcm-sender.interface';
import { UsersModule } from '../users/users.module';
import { VenuesModule } from '../venues/venues.module';
import { GoingModule } from '../going/going.module';
import { FeedModule } from '../feed/feed.module';

/**
 * No real FCM project is configured for this environment yet (tracked
 * separately, out of scope here — see docs/validation-mvp specs).
 * `FakeFcmSender` is the only implementation today; a real one slots in
 * behind the same `FcmSender` interface without touching job logic.
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([
      DeviceToken,
      NotificationPreference,
      SentNotification,
      VenueBroadcastOptIn,
    ]),
    BullModule.registerQueue({ name: NOTIFICATIONS_QUEUE }),
    UsersModule,
    VenuesModule,
    GoingModule,
    FeedModule,
  ],
  controllers: [NotificationsController],
  providers: [
    NotificationsService,
    NotificationsProcessor,
    NotificationsScheduler,
    FakeFcmSender,
    FirebaseFcmSender,
    {
      provide: FCM_SENDER,
      inject: [ConfigService, FakeFcmSender, FirebaseFcmSender],
      useFactory: (
        config: ConfigService,
        fake: FakeFcmSender,
        firebase: FirebaseFcmSender,
      ) => {
        const configured = !!(
          config.get<string>('FIREBASE_PROJECT_ID') ||
          config.get<string>('FIREBASE_SERVICE_ACCOUNT_BASE64')
        );
        if (!configured) {
          const nodeEnv = config.get<string>('NODE_ENV', 'development');
          if (nodeEnv === 'production' || nodeEnv === 'staging') {
            new Logger('NotificationsModule').error(
              'No Firebase project is configured; falling back to FakeFcmSender. Push notifications will not be delivered.',
            );
          }
          return fake;
        }
        return firebase;
      },
    },
  ],
  exports: [NotificationsService],
})
export class NotificationsModule {}
