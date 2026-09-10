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

const reviewTexts = [
  'Amazing vibe and great music selection. The DJ really knows how to keep the energy going all night long in Abidjan.',
  'Overpriced drinks and the service was incredibly slow. Waited 40 minutes for a simple cocktail. Not coming back.',
  'Best nightlife spot on the island! The outdoor terrace has a stunning view of the Abidjan lagoon. Highly recommend.',
  'The VIP section is worth every naira. Premium service, dedicated waitstaff, and top-shelf bottles.',
  'Average experience. Music was too loud to have a conversation, but the atmosphere was decent for a Saturday night.',
  'Absolutely loved the live band performance. Afrobeats and highlife classics — pure Abidjan energy.',
  'Security was rude and the bouncers were very aggressive at the door. Killed the entire mood before we even got in.',
  'Perfect for date night. Intimate setting, great cocktails, and the dim lighting creates a wonderful ambiance.',
  'This place has gone downhill. Used to be the best in Lekki but now it feels neglected. Dirty restrooms.',
  'Weekend special was incredible! Free entry before 10pm and half-price on selected cocktails. Great deal.',
  'The food menu is surprisingly good for a nightclub. The suya platter and jollof rice were both excellent.',
  'Parking is a nightmare. We circled for 30 minutes before finding a spot. They need valet service.',
  'Best birthday celebration ever! The staff went above and beyond to make it special. Sparklers, cake, the works.',
  'Music selection needs work. Playing the same tracks on repeat. DJs should diversify their playlist.',
  'Love the new renovation. The indoor lounge area feels much more spacious and the decor is very modern.',
  'Drinks are reasonably priced compared to other spots on Victoria Island. The cocktail menu is creative.',
  'Terrible sound system. The bass was distorted and you could barely hear the vocals. Very disappointing.',
  'Great place to unwind after a long week. The rooftop bar has the best sunset views in Abidjan.',
  'Staff was incredibly friendly and attentive. They remembered our names by the second visit.',
  'Not worth the hype. Went on a Friday and it was half empty. The online buzz does not match reality.',
  'The themed nights are brilliant. Throwback Thursday with 90s music is my absolute favorite.',
  'Cocktails are creative but the portions are small for the price. Style over substance unfortunately.',
  'One of the few places in Abidjan where you feel genuinely safe. Well-managed security and CCTV everywhere.',
  'The AC was broken during our visit. In Abidjan heat that is unforgivable. Fix your infrastructure.',
  'Hands down the best karaoke night in town. Great song selection and the crowd is always supportive.',
]

export const reviews = Array.from({ length: 25 }, (_, i) => {
  const name = nigerianNames[i] ?? faker.person.fullName()
  const isFlagged = faker.helpers.weightedArrayElement([
    { weight: 3, value: true },
    { weight: 7, value: false },
  ])
  return {
    id: faker.string.uuid(),
    userName: name,
    userEmail: faker.internet
      .email({
        firstName: name.split(' ')[0],
        lastName: name.split(' ')[1],
      })
      .toLowerCase(),
    venueName: faker.helpers.arrayElement(AbidjanVenues),
    rating: faker.helpers.arrayElement([
      1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.0, 4.5, 4.5, 5.0, 5.0,
    ]),
    text: reviewTexts[i] ?? faker.lorem.sentences(2),
    isFlagged,
    isHidden: isFlagged
      ? faker.helpers.weightedArrayElement([
          { weight: 4, value: true },
          { weight: 6, value: false },
        ])
      : false,
    createdAt: faker.date.past({ years: 1 }),
  }
})
