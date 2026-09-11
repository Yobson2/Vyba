export interface LatLng {
  lat: number;
  lng: number;
}

/**
 * Zone 4 / Marcory, Abidjan — the single canonical launch-area polygon
 * (one commune only; no multi-area support by design, see ADR-0001 /
 * VYBA_VALIDATION_MVP_SPEC.md §2). Approximate bounding box pending
 * refinement with the Vyba team's own GPS survey of the launch area —
 * precise boundary drawing is an operational task, not an engineering one.
 */
export const LAUNCH_AREA_POLYGON: LatLng[] = [
  { lat: 5.2975, lng: -3.9995 },
  { lat: 5.2975, lng: -3.973 },
  { lat: 5.273, lng: -3.973 },
  { lat: 5.273, lng: -3.9995 },
];

/**
 * Ray-casting point-in-polygon test against [LAUNCH_AREA_POLYGON]. Every
 * query/metric that needs "is this venue in the launch area" must go
 * through this single function.
 */
export function pointInLaunchArea(lat: number, lng: number): boolean {
  let inside = false;
  const polygon = LAUNCH_AREA_POLYGON;

  for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    const xi = polygon[i].lng;
    const yi = polygon[i].lat;
    const xj = polygon[j].lng;
    const yj = polygon[j].lat;

    const intersects =
      yi > lat !== yj > lat && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi;
    if (intersects) inside = !inside;
  }

  return inside;
}
