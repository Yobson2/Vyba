import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { FeedItemCard } from '@/components/FeedItemCard';
import { mockFeed } from './msw/handlers';

describe('FeedItemCard', () => {
  it('renders a live_tonight card with the venue name', () => {
    render(<FeedItemCard item={mockFeed[0]} />);
    expect(screen.getByText('EN CE MOMENT')).toBeInTheDocument();
    expect(screen.getByText('Le Boony')).toBeInTheDocument();
  });

  it('renders a promo card with the title and description', () => {
    render(<FeedItemCard item={mockFeed[1]} />);
    expect(screen.getByText('PROMO')).toBeInTheDocument();
    expect(screen.getByText('Happy hour -50%')).toBeInTheDocument();
    expect(screen.getByText("Jusqu'à 23h")).toBeInTheDocument();
  });

  it('links to the venue page when a venue is attached', () => {
    render(<FeedItemCard item={mockFeed[0]} />);
    expect(screen.getByRole('link')).toHaveAttribute('href', '/venue-1');
  });
});
