import type { Admin } from './schema'

export const mockAdmins: Admin[] = [
  {
    id: '1',
    name: 'Super Admin',
    email: 'admin@vyba.app',
    role: 'super_admin',
    status: 'active',
    lastActive: new Date(),
    createdAt: new Date('2025-01-15'),
  },
  {
    id: '2',
    name: 'Chinedu Okafor',
    email: 'chinedu@vyba.app',
    role: 'admin',
    status: 'active',
    lastActive: new Date('2026-05-19'),
    createdAt: new Date('2025-03-01'),
  },
  {
    id: '3',
    name: 'Amaka Eze',
    email: 'amaka@vyba.app',
    role: 'manager',
    status: 'active',
    lastActive: new Date('2026-05-18'),
    createdAt: new Date('2025-06-15'),
  },
  {
    id: '4',
    name: 'Tunde Bakare',
    email: 'tunde@vyba.app',
    role: 'support',
    status: 'invited',
    lastActive: null,
    createdAt: new Date('2026-05-10'),
  },
  {
    id: '5',
    name: 'Kemi Adeyemi',
    email: 'kemi@vyba.app',
    role: 'viewer',
    status: 'deactivated',
    lastActive: new Date('2026-04-01'),
    createdAt: new Date('2025-09-20'),
  },
]
