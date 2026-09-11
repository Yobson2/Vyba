export const SMS_PROVIDER = 'SMS_PROVIDER';

export interface SmsDeliveryResult {
  accepted: boolean;
  /** Non-PII reason code for a failed send (e.g. 'PROVIDER_ERROR'). Never the code or number. */
  reason?: string;
}

/**
 * One send() contract for every OTP transport (SMS today, WhatsApp later) so
 * auth logic never depends on a specific vendor.
 */
export interface SmsProvider {
  send(phoneE164: string, message: string): Promise<SmsDeliveryResult>;
}
