import { faker } from '@faker-js/faker'

const nigerianCities = ['Abidjan', 'Abuja', 'Port Harcourt', 'Ibadan', 'Kano']
const nigerianNames = [
  'Adeola Johnson',
  'Tunde Bakare',
  'Chioma Nwankwo',
  'Ifeanyi Okeke',
  'Ngozi Adeyemi',
  'Emeka Obi',
  'Funke Akindele',
  'Yemi Alade',
  'Obinna Eze',
  'Amara Kalu',
  'Dayo Okoro',
  'Kemi Fashola',
  'Segun Adeniyi',
  'Bola Tinubu-Smith',
  'Chidi Nwosu',
  'Aisha Mohammed',
  'Babajide Sanwo',
  'Folake Dosumu',
  'Uche Nnadi',
  'Rashida Bello',
]

export const users = Array.from({ length: 20 }, (_, i) => ({
  id: faker.string.uuid(),
  name: nigerianNames[i] ?? faker.person.fullName(),
  email: faker.internet
    .email({
      firstName: nigerianNames[i]?.split(' ')[0],
      lastName: nigerianNames[i]?.split(' ')[1],
    })
    .toLowerCase(),
  phone: `+234${faker.string.numeric(10)}`,
  avatarUrl: faker.helpers.maybe(() => faker.image.avatar(), {
    probability: 0.6,
  }) ?? null,
  role: faker.helpers.arrayElement(['CLIENT', 'VENUE_OWNER'] as const),
  status: faker.helpers.arrayElement([
    'active',
    'active',
    'active',
    'inactive',
    'suspended',
    'banned',
  ] as const),
  city: faker.helpers.arrayElement(nigerianCities),
  acquisitionSource: faker.helpers.arrayElement([
    'qr',
    'qr',
    'web',
    'referral',
    'organic',
    'campaign',
  ] as const),
  createdAt: faker.date.past({ years: 1 }),
  updatedAt: faker.date.recent({ days: 30 }),
}))
