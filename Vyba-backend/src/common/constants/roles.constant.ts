/**
 * Role Constants - Single Source of Truth for User Roles
 *
 * All role-related code MUST use these constants instead of hardcoded strings.
 * Vyba actors: platform staff (ADMIN), venue owners (VENUE_OWNER), end users (CLIENT).
 */

export enum UserRole {
  ADMIN = 'ADMIN',
  VENUE_OWNER = 'VENUE_OWNER',
  CLIENT = 'CLIENT',
}

/** Role assigned to a self-registered user (phone-OTP verified). */
export const DEFAULT_ROLE = UserRole.CLIENT;

export const VALID_USER_ROLES: readonly UserRole[] = [
  UserRole.ADMIN,
  UserRole.VENUE_OWNER,
  UserRole.CLIENT,
] as const;

export const ROLE_METADATA = {
  [UserRole.ADMIN]: {
    displayName: 'Admin',
    description: 'Vyba platform staff. Full access to all features and data.',
  },
  [UserRole.VENUE_OWNER]: {
    displayName: 'Venue Owner',
    description:
      'Manages their own venue: nights, promotions and venue content.',
  },
  [UserRole.CLIENT]: {
    displayName: 'Client',
    description:
      'End user: discovers venues, follows them and marks "J\'y vais".',
  },
} as const;

export function isUserRole(value: unknown): value is UserRole {
  return (
    typeof value === 'string' && VALID_USER_ROLES.includes(value as UserRole)
  );
}

export type UserRoleType = UserRole;
