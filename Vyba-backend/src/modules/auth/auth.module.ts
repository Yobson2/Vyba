import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { OtpStoreService } from './otp-store.service';
import { UsersModule } from '../users/users.module';
import { SmsModule } from '@common/sms/sms.module';

@Module({
  imports: [UsersModule, SmsModule],
  controllers: [AuthController],
  providers: [AuthService, OtpStoreService],
})
export class AuthModule {}
