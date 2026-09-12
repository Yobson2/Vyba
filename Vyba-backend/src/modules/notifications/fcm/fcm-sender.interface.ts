export const FCM_SENDER = 'FCM_SENDER';

export interface FcmPayload {
  title: string;
  body: string;
  /** Deep-link routing for the mobile tap handler — never PII (spec 08). */
  data?: Record<string, string>;
}

export interface FcmSendResult {
  deliveredTokens: string[];
  invalidTokens: string[];
}

/**
 * One send contract for every push transport (FCM today) so
 * `NotificationsService` never depends on the Firebase Admin SDK directly.
 */
export interface FcmSender {
  send(tokens: string[], payload: FcmPayload): Promise<FcmSendResult>;
}
