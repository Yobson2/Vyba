/** Tunables for the phone-OTP flow. Recommended values from the auth spec. */
export const OTP_CODE_LENGTH = 6;
export const OTP_CODE_TTL_SECONDS = 5 * 60;
export const OTP_RESEND_COOLDOWN_SECONDS = 60;
export const OTP_MAX_VERIFY_ATTEMPTS = 5;

export const OTP_PHONE_RATE_LIMIT_MAX = 5;
export const OTP_PHONE_RATE_LIMIT_WINDOW_SECONDS = 15 * 60;

export const OTP_IP_RATE_LIMIT_MAX = 20;
export const OTP_IP_RATE_LIMIT_WINDOW_SECONDS = 15 * 60;
