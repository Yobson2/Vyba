import { type SVGProps } from 'react'

/**
 * Vyba pulse mark — V-shaped heartbeat wave with neon pulse dot.
 * Gradient version for dark backgrounds (primary use).
 */
export function Logo({ ...props }: SVGProps<SVGSVGElement>) {
  return (
    <svg
      xmlns='http://www.w3.org/2000/svg'
      viewBox='0 0 140 100'
      fill='none'
      {...props}
    >
      <defs>
        <linearGradient
          id='vyba-pulse-grad'
          x1='0'
          y1='0'
          x2='140'
          y2='140'
          gradientUnits='userSpaceOnUse'
        >
          <stop offset='0%' stopColor='#B0A3FF' />
          <stop offset='100%' stopColor='#6C5CE7' />
        </linearGradient>
      </defs>
      <path
        d='M8 68 L38 68 L64 16 L72 16 L98 68 L128 68 L128 78 L94 78 L69 32 L44 78 L8 78 Z'
        fill='url(#vyba-pulse-grad)'
      />
      <circle cx='116' cy='46' r='8' fill='#FF2D78' />
    </svg>
  )
}

/**
 * Full wordmark logo (pulse mark + "Vyba" text).
 * Uses currentColor for text to adapt to theme.
 */
export function LogoFull({ ...props }: SVGProps<SVGSVGElement>) {
  return (
    <svg
      xmlns='http://www.w3.org/2000/svg'
      viewBox='0 0 520 160'
      fill='none'
      {...props}
    >
      <defs>
        <linearGradient
          id='vyba-full-grad'
          x1='0'
          y1='0'
          x2='140'
          y2='140'
          gradientUnits='userSpaceOnUse'
        >
          <stop offset='0%' stopColor='#B0A3FF' />
          <stop offset='100%' stopColor='#6C5CE7' />
        </linearGradient>
      </defs>

      {/* Pulse Mark */}
      <g transform='translate(0, 10)'>
        <path
          d='M8 78 L38 78 L64 26 L72 26 L98 78 L128 78 L128 88 L94 88 L69 42 L44 88 L8 88 Z'
          fill='url(#vyba-full-grad)'
        />
        <circle cx='116' cy='56' r='8' fill='#FF2D78' />
      </g>

      {/* Wordmark — uses currentColor to adapt to light/dark */}
      <text
        x='152'
        y='105'
        fill='currentColor'
        fontFamily="'Epilogue', sans-serif"
        fontWeight='700'
        fontSize='72'
        letterSpacing='-1.5px'
      >
        Vyba
      </text>

      {/* Tagline */}
      <text
        x='156'
        y='132'
        fill='currentColor'
        opacity='0.5'
        fontFamily="'Inter', sans-serif"
        fontWeight='500'
        fontSize='16'
        letterSpacing='4px'
      >
        Abidjan PULSE
      </text>
    </svg>
  )
}
