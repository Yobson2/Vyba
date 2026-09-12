import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { VenueTonightBlock } from '@/components/VenueTonightBlock';
import { mockVenueLive } from './msw/handlers';

describe('VenueTonightBlock', () => {
  it('shows "rien d\'annoncé ce soir" when there is no VenueNight', () => {
    render(<VenueTonightBlock tonight={null} />);
    expect(screen.getByText(/rien d'annoncé ce soir/i)).toBeInTheDocument();
  });

  it('shows "rien d\'annoncé ce soir" when the night is not live, with the going count', () => {
    render(
      <VenueTonightBlock
        tonight={{
          isLive: false,
          liveSince: null,
          headline: null,
          djName: null,
          goingCount: 3,
        }}
      />,
    );
    expect(screen.getByText(/rien d'annoncé ce soir/i)).toBeInTheDocument();
    expect(screen.getByText('3 y vont')).toBeInTheDocument();
  });

  it('shows the live state, headline and going count', () => {
    render(<VenueTonightBlock tonight={mockVenueLive.tonight} />);
    expect(screen.getByText(/c'est live/i)).toBeInTheDocument();
    expect(screen.getByText(/dj kobo ce soir/i)).toBeInTheDocument();
    expect(
      screen.getByText(/8 personnes y vont ce soir/i),
    ).toBeInTheDocument();
  });
});
