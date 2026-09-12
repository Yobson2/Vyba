'use client';

import { useState } from 'react';
import { ApiError, otpErrorMessage, requestCode, verifyCode } from '@/lib/auth-api';
import { getOrCreateClientId } from '@/lib/client-id';
import { NoSessionError, markGoing } from '@/lib/going-api';
import { getSession, setSession } from '@/lib/session';
import type { VenueTonight } from '@/lib/types';
import { AppDownloadPrompt } from './AppDownloadPrompt';
import { VenueTonightBlock } from './VenueTonightBlock';

const COUNTRY_CODE = '+225';
const NATIONAL_NUMBER_LENGTH = 10;

type FlowStep =
  | { name: 'idle' }
  | { name: 'phone'; error?: string }
  | { name: 'code'; phone: string; error?: string }
  | { name: 'marking' }
  | { name: 'done' };

/**
 * The venue page's "J'y vais" (spec 14): marks directly when a session
 * already exists, otherwise a phone → code → verify flow first. The going
 * count is bumped optimistically on success — this page never re-fetches.
 */
export function GoingSection({
  venueId,
  tonight,
}: {
  venueId: string;
  tonight: VenueTonight | null;
}) {
  const [step, setStep] = useState<FlowStep>({ name: 'idle' });
  const [nationalNumber, setNationalNumber] = useState('');
  const [code, setCode] = useState('');
  const [ageConfirmed, setAgeConfirmed] = useState(false);
  const [count, setCount] = useState(tonight?.goingCount ?? 0);

  const displayedTonight: VenueTonight | null = tonight
    ? { ...tonight, goingCount: count }
    : count > 0
      ? {
          isLive: false,
          liveSince: null,
          headline: null,
          djName: null,
          goingCount: count,
        }
      : null;

  async function handleMarkWithSession() {
    setStep({ name: 'marking' });
    try {
      await markGoing(venueId);
      setCount((c) => c + 1);
      setStep({ name: 'done' });
    } catch (err) {
      if (err instanceof NoSessionError) {
        setStep({ name: 'phone' });
        return;
      }
      setStep({ name: 'phone', error: 'Une erreur est survenue. Réessayez.' });
    }
  }

  function handleTapGoing() {
    if (getSession()) {
      void handleMarkWithSession();
      return;
    }
    setStep({ name: 'phone' });
  }

  async function handleSubmitPhone(event: React.FormEvent) {
    event.preventDefault();
    if (nationalNumber.length !== NATIONAL_NUMBER_LENGTH) {
      setStep({
        name: 'phone',
        error: `Entrez un numéro à ${NATIONAL_NUMBER_LENGTH} chiffres.`,
      });
      return;
    }
    const phone = `${COUNTRY_CODE}${nationalNumber}`;
    try {
      await requestCode(phone);
      setCode('');
      setStep({ name: 'code', phone });
    } catch (err) {
      const message =
        err instanceof ApiError
          ? otpErrorMessage(err.code)
          : 'Une erreur est survenue. Réessayez.';
      setStep({ name: 'phone', error: message });
    }
  }

  async function handleSubmitCode(event: React.FormEvent) {
    event.preventDefault();
    const current = step;
    if (current.name !== 'code') return;

    try {
      const session = await verifyCode({
        phone: current.phone,
        code,
        ageConfirmed,
        clientId: getOrCreateClientId(),
      });
      setSession(session);
      await handleMarkWithSession();
    } catch (err) {
      const message =
        err instanceof ApiError
          ? otpErrorMessage(err.code)
          : 'Une erreur est survenue. Réessayez.';
      setStep({ name: 'code', phone: current.phone, error: message });
    }
  }

  return (
    <div className="going-section">
      <VenueTonightBlock tonight={displayedTonight} />

      {step.name === 'idle' && (
        <button
          type="button"
          className="button button--primary"
          onClick={handleTapGoing}
        >
          J&apos;y vais
        </button>
      )}

      {step.name === 'phone' && (
        <form className="otp-form" onSubmit={handleSubmitPhone}>
          <label className="otp-form__label" htmlFor="phone-input">
            Ton numéro de téléphone
          </label>
          <div className="otp-form__phone-row">
            <span className="otp-form__country-code">{COUNTRY_CODE}</span>
            <input
              id="phone-input"
              type="tel"
              inputMode="numeric"
              autoComplete="tel-national"
              placeholder="0700000000"
              value={nationalNumber}
              onChange={(e) =>
                setNationalNumber(e.target.value.replace(/\D/g, '').slice(0, NATIONAL_NUMBER_LENGTH))
              }
              className="otp-form__input"
            />
          </div>
          {step.error && <p className="otp-form__error">{step.error}</p>}
          <button type="submit" className="button button--primary">
            Recevoir le code
          </button>
        </form>
      )}

      {step.name === 'code' && (
        <form className="otp-form" onSubmit={handleSubmitCode}>
          <label className="otp-form__label" htmlFor="code-input">
            Code reçu par SMS au {step.phone}
          </label>
          <input
            id="code-input"
            type="text"
            inputMode="numeric"
            autoComplete="one-time-code"
            placeholder="000000"
            value={code}
            onChange={(e) => setCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
            className="otp-form__input"
          />
          <label className="otp-form__checkbox">
            <input
              type="checkbox"
              checked={ageConfirmed}
              onChange={(e) => setAgeConfirmed(e.target.checked)}
            />
            J&apos;ai 18 ans ou plus.
          </label>
          {step.error && <p className="otp-form__error">{step.error}</p>}
          <button
            type="submit"
            className="button button--primary"
            disabled={code.length !== 6 || !ageConfirmed}
          >
            Vérifier
          </button>
          <button
            type="button"
            className="otp-form__resend"
            onClick={() => void requestCode(step.phone)}
          >
            Renvoyer le code
          </button>
        </form>
      )}

      {step.name === 'marking' && (
        <button type="button" className="button button--primary" disabled>
          Envoi...
        </button>
      )}

      {step.name === 'done' && (
        <>
          <p className="going-section__confirmation">
            C&apos;est noté, à ce soir !
          </p>
          <AppDownloadPrompt />
        </>
      )}
    </div>
  );
}
