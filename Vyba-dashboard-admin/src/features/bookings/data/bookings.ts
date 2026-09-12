import { faker } from '@faker-js/faker'

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
  'Temi Otedola',
  'Kunle Afolabi',
  'Ifeoma Chukwu',
  'Sade Adu',
  'Olumide Ogunleye',
  'Halima Dangote',
  'Chinedu Ikedi',
  'Yetunde Shobande',
  'Kola Balogun',
  'Zainab Aliyu',
]

const AbidjanVenues = [
  'Club Quilox',
  'The Place',
  'Hard Rock Cafe Abidjan',
  'Shiro Abidjan',
  'Escape Nightclub',
  'Sky Lounge VI',
  'Ember Creek',
  'NOK by Alara',
  'Craft Gourmet',
  'RSVP Abidjan',
  'The Vault Lounge',
  'Mood Bar & Grill',
  'Afropolitan Vibes',
  'Terra Kulture',
  'Balmoral Convention',
]

const timeSlots = ['19:00', '20:00', '21:00', '22:00', '23:00'] as const
const prefixes = ['VIB', 'NIT', 'RSV', 'BKG', 'CLB']

export const bookings = Array.from({ length: 30 }, (_, i) => {
  const name = nigerianNames[i] ?? faker.person.fullName()
  return {
    id: faker.string.uuid(),
    reference: `LP-${faker.helpers.arrayElement(prefixes)}-${faker.string.numeric(4)}`,
    guestName: name,
    guestEmail: faker.internet
      .email({
        firstName: name.split(' ')[0],
        lastName: name.split(' ')[1],
      })
      .toLowerCase(),
    venueName: faker.helpers.arrayElement(AbidjanVenues),
    date: faker.date.soon({ days: 30 }),
    timeSlot: faker.helpers.arrayElement(timeSlots),
    guestCount: faker.number.int({ min: 1, max: 12 }),
    zone: faker.helpers.arrayElement([
      'indoor_lounge',
      'outdoor_terrace',
      'vip_booth',
    ] as const),
    status: faker.helpers.arrayElement([
      'confirmed',
      'confirmed',
      'confirmed',
      'pending',
      'pending',
      'completed',
      'cancelled',
    ] as const),
    depositAmount: faker.number.int({ min: 5, max: 50 }) * 1000,
    createdAt: faker.date.past({ years: 1 }),
  }
})
