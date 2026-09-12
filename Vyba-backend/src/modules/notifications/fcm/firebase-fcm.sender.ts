import { Injectable } from '@nestjs/common';
import { FirebaseService } from '@common/firebase/firebase.service';
import { FcmPayload, FcmSendResult, FcmSender } from './fcm-sender.interface';

@Injectable()
export class FirebaseFcmSender implements FcmSender {
  constructor(private readonly firebase: FirebaseService) {}

  async send(tokens: string[], payload: FcmPayload): Promise<FcmSendResult> {
    if (tokens.length === 0) {
      return { deliveredTokens: [], invalidTokens: [] };
    }

    const result = await this.firebase.sendMulticastPushNotification(tokens, {
      title: payload.title,
      body: payload.body,
      data: payload.data,
    });

    const invalidTokens = result.failedTokens;
    const deliveredTokens = tokens.filter((t) => !invalidTokens.includes(t));
    return { deliveredTokens, invalidTokens };
  }
}
