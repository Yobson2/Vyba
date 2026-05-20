# Design System Document: Nightlife West Africa

## 1. Creative North Star: "The Neon Curator"
This design system moves beyond the "utility app" feel to create a high-end, editorial experience that mirrors the energy of West African nightlife. We are building **"The Neon Curator"**—a system that feels like a premium concierge. 

The aesthetic identity is defined by **Intentional Asymmetry** and **Tonal Depth**. We reject the "boxed-in" look of standard mobile templates. Instead, we use overlapping elements, dramatic typography scales, and "glass" surfaces to create an interface that feels alive, fluid, and immersive. This is not a directory; it is a digital invitation to the night.

---

## 2. Color & Surface Philosophy

### The Palette
We utilize a sophisticated Material-inspired palette where the core colors are elevated through tonal variants.
- **Primary (`#a3a6ff` / `#6366F1`):** Our signature electric indigo. Use `primary_dim` for a moody, late-night feel and `primary_fixed` for high-impact CTAs.
- **Secondary (`#69f6b8` / `#10B981`):** "Lagos Emerald." Reserved strictly for availability and positive status.
- **Tertiary (`#ffb148` / `#F59E0B`):** "Golden Hour." Used exclusively for promotions, VIP tiers, and high-value highlights.

### The "No-Line" Rule
**Explicit Instruction:** 1px solid borders are strictly prohibited for sectioning. We define boundaries through background shifts or subtle tonal transitions.
- To separate a card from the background, place a `surface_container_low` element on a `surface` background.
- For deep nesting, use `surface_container_highest` for the most prominent interactive elements.

### The "Glass & Gradient" Rule
To capture the "vibrant" vibe, all primary CTAs must use a linear gradient from `primary` to `primary_dim` at a 135-degree angle. Floating headers and navigation bars must utilize **Glassmorphism**: use `surface_variant` at 60% opacity with a `20px` backdrop blur. This allows the photography-forward content to bleed through, creating a "frosted glass" look that feels integrated and premium.

---

## 3. Typography: Editorial Authority

We use a dual-font strategy to balance clean readability with high-fashion editorial impact.

- **Headline & Display (Epilogue):** Chosen for its geometric weight and personality. Use `display-lg` for hero headers (e.g., "Tonight in Accra") with `-0.04em` letter spacing to create a tight, professional look.
- **Body & Labels (Inter):** The workhorse. Inter provides the modern, clean clarity required for dense information like addresses and pricing.

**Hierarchy as Brand:** 
- Use `headline-lg` for venue names to convey authority.
- Use `label-sm` in all-caps with `0.1em` tracking for metadata (e.g., "OPEN UNTIL 4AM") to create an upscale, magazine-like feel.

---

## 4. Elevation & Depth: Tonal Layering

We eschew traditional drop shadows for **Tonal Layering**. Depth is a physical stack of surfaces:

1.  **Level 0 (Base):** `surface` or `surface_container_lowest` (the "floor").
2.  **Level 1 (Sections):** `surface_container_low` (subtle grouping).
3.  **Level 2 (Interactive Cards):** `surface_container_high`.

### Ambient Shadows
When an element must "float" (e.g., a "Book Table" button), use a tinted shadow:
- **Shadow Color:** 8% opacity of `on_surface`.
- **Blur:** 24px.
- **Spread:** -4px.
This creates a soft, natural lift rather than a harsh, artificial shadow.

### The "Ghost Border" Fallback
If a border is required for accessibility, it must be a **Ghost Border**: `outline_variant` at 15% opacity. Never use 100% opaque lines.

---

## 5. Signature Components

### Buttons: The "Pulse" Variant
- **Primary:** Gradient (`primary` to `primary_dim`), `12px` radius. Text is `on_primary_fixed`, heavy weight.
- **Tertiary (Promotional):** `tertiary_fixed` background with `on_tertiary_fixed` text. Used only for "Featured Events."

### Cards: The "Cinematic" Card
For venue discovery, use a vertical card where the image occupies 100% of the container. Use a `surface_container_highest` scrim (gradient overlay) at the bottom to house the `title-md` and `label-md` text. **No dividers.** Use `16px` vertical white space to separate card groups.

### Status Chips
- **Availability:** `secondary_container` background with `on_secondary_container` text.
- **Radius:** `full` (pill shape).
- These should float in the top-right corner of venue cards using the Glassmorphism rule.

### Input Fields
- Background: `surface_container_highest`.
- Border: None, unless focused. On focus, use a 2px `primary` bottom-border only (Editorial style).

---

## 6. Do’s and Don’ts

### Do:
- **Do** use intentional asymmetry. Offset a venue image by 8px from the text alignment to create a "custom" look.
- **Do** use large, high-quality photography as the primary UI driver.
- **Do** stack surface containers to create hierarchy (`surface` > `surface_container_low` > `surface_container_high`).

### Don’t:
- **Don’t** use standard #000000 shadows. Always tint shadows with the `on_surface` token.
- **Don’t** use dividers or "hairline" borders. Use whitespace or color-blocking instead.
- **Don’t** use the `secondary` (Emerald) color for anything other than availability or success. It is a functional signal, not an aesthetic one.
- **Don’t** clutter the screen. If a section feels crowded, increase the spacing by one level on the scale rather than adding a border.

---

## 7. Token Reference Summary

| Role | Token Value | Usage |
| :--- | :--- | :--- |
| **Primary Base** | `#a3a6ff` | Branding, active states, key icons. |
| **Surface Base** | `#060e20` | The primary dark-mode canvas. |
| **Surface High** | `#141f38` | The standard "Card" surface. |
| **On Surface** | `#dee5ff` | High-contrast body text. |
| **Accent** | `#f8a010` | "VIP" and "Flash Sale" highlights. |
| **Radius** | `12px` (md) | Standard for cards, buttons, and inputs. |