/**
 * Dashboard-access accounts are Vyba team members. During the validation phase
 * the only role the dashboard issues is `ADMIN`; the shared role vocabulary lives
 * in `./roles` and is mirrored from the backend.
 */
export type { UserRole as AdminRole } from './roles'
export { USER_ROLES as ADMIN_ROLES, ROLE_LABELS } from './roles'
