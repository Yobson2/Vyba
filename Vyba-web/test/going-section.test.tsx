import { fireEvent, render, screen, waitFor } from '@testing-library/react';
import { http, HttpResponse } from 'msw';
import { afterEach, describe, expect, it } from 'vitest';
import { GoingSection } from '@/components/GoingSection';
import { setSession } from '@/lib/session';
import { server } from './setup';
import { mockSession, mockVenueLive, OTP_CODE } from './msw/handlers';

const API_BASE = 'http://localhost:3000';

describe('GoingSection', () => {
  afterEach(() => {
    delete process.env.NEXT_PUBLIC_PLAY_STORE_URL;
  });

  it('with an existing session, "J\'y vais" calls the mark endpoint directly — no phone/code shown', async () => {
    setSession(mockSession);
    let markedVenueId: string | undefined;
    server.use(
      http.post(`${API_BASE}/api/going`, async ({ request }) => {
        const body = (await request.json()) as { venueId?: string };
        markedVenueId = body.venueId;
        return HttpResponse.json({ id: 'going-1' }, { status: 201 });
      }),
    );

    render(
      <GoingSection venueId={mockVenueLive.id} tonight={mockVenueLive.tonight} />,
    );

    fireEvent.click(screen.getByRole('button', { name: /j'y vais/i }));

    await waitFor(() => {
      expect(screen.getByText(/à ce soir/i)).toBeInTheDocument();
    });
    expect(markedVenueId).toBe(mockVenueLive.id);
    expect(screen.queryByLabelText(/ton numéro/i)).not.toBeInTheDocument();
    expect(screen.getByText('9 personnes y vont ce soir')).toBeInTheDocument();
  });

  it('without a session: phone → code → verify → mark, then the count goes up', async () => {
    let verifyClientId: string | undefined;
    server.use(
      http.post(`${API_BASE}/api/auth/verify-code`, async ({ request }) => {
        const body = (await request.json()) as { clientId?: string };
        verifyClientId = body.clientId;
        return HttpResponse.json({
          user: { id: 'user-1' },
          accessToken: mockSession.accessToken,
          refreshToken: mockSession.refreshToken,
        });
      }),
    );

    render(
      <GoingSection venueId={mockVenueLive.id} tonight={mockVenueLive.tonight} />,
    );

    fireEvent.click(screen.getByRole('button', { name: /j'y vais/i }));

    const phoneInput = await screen.findByPlaceholderText('0700000000');
    fireEvent.change(phoneInput, { target: { value: '0700000000' } });
    fireEvent.click(screen.getByRole('button', { name: /recevoir le code/i }));

    const codeInput = await screen.findByPlaceholderText('000000');
    fireEvent.change(codeInput, { target: { value: OTP_CODE } });
    fireEvent.click(screen.getByLabelText(/18 ans ou plus/i));
    fireEvent.click(screen.getByRole('button', { name: /vérifier/i }));

    await waitFor(() => {
      expect(screen.getByText(/à ce soir/i)).toBeInTheDocument();
    });
    expect(screen.getByText('9 personnes y vont ce soir')).toBeInTheDocument();
    // Ties this signup to the landing event `AttributionCapture` recorded
    // under the same client id (spec 07/14's join key).
    expect(verifyClientId).toBeTruthy();
  });

  it('an incorrect code shows an inline error and does not mark', async () => {
    render(
      <GoingSection venueId={mockVenueLive.id} tonight={mockVenueLive.tonight} />,
    );

    fireEvent.click(screen.getByRole('button', { name: /j'y vais/i }));
    const phoneInput = await screen.findByPlaceholderText('0700000000');
    fireEvent.change(phoneInput, { target: { value: '0700000000' } });
    fireEvent.click(screen.getByRole('button', { name: /recevoir le code/i }));

    const codeInput = await screen.findByPlaceholderText('000000');
    fireEvent.change(codeInput, { target: { value: '000000' } });
    fireEvent.click(screen.getByLabelText(/18 ans ou plus/i));
    fireEvent.click(screen.getByRole('button', { name: /vérifier/i }));

    await waitFor(() => {
      expect(screen.getByText(/code incorrect/i)).toBeInTheDocument();
    });
    expect(screen.getByText('8 personnes y vont ce soir')).toBeInTheDocument();
  });

  it('the app-download prompt does not render before a completed action', () => {
    process.env.NEXT_PUBLIC_PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=x';
    render(
      <GoingSection venueId={mockVenueLive.id} tonight={mockVenueLive.tonight} />,
    );
    expect(
      screen.queryByRole('link', { name: /télécharge l'app/i }),
    ).not.toBeInTheDocument();
  });

  it('the app-download prompt appears only after a completed "J\'y vais"', async () => {
    process.env.NEXT_PUBLIC_PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=x';
    setSession(mockSession);

    render(
      <GoingSection venueId={mockVenueLive.id} tonight={mockVenueLive.tonight} />,
    );
    fireEvent.click(screen.getByRole('button', { name: /j'y vais/i }));

    await waitFor(() => {
      expect(
        screen.getByRole('link', { name: /télécharge l'app/i }),
      ).toBeInTheDocument();
    });
  });
});
