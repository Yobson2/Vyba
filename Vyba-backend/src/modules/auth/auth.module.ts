import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { OtpStoreService } from './otp-store.service';
import { AdminSeedService } from './admin-seed.service';
import { AdminCredential } from './entities/admin-credential.entity';
import { UsersModule } from '../users/users.module';
import { SmsModule } from '@common/sms/sms.module';
import { AttributionModule } from '@modules/attribution/attribution.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([AdminCredential]),
    UsersModule,
    SmsModule,
    AttributionModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, OtpStoreService, AdminSeedService],
})
export class AuthModule {}
