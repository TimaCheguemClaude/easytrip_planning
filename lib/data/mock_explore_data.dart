// Mock data for explore city page
class MockExploreData {
  static const List<String> categories = [
    'places_to_stay',
    'food_and_drinks',
    'things_to_do',
    'touristic_sites',
  ];

  static List<Map<String, dynamic>> getPopularDestinations(String city) {
    final cityData = cityCategoryData[city];
    if (cityData == null) return [];
    // Aggregate all items from all categories
    final allItems = <Map<String, dynamic>>[];
    for (final category in cityData.values) {
      allItems.addAll(category);
    }
    // Sort by likes descending, fallback to stars if likes missing
    allItems.sort((a, b) {
      final aLikes = a['likes'] ?? 0;
      final bLikes = b['likes'] ?? 0;
      if (aLikes != bLikes) return bLikes.compareTo(aLikes);
      // fallback: sort by stars
      return (b['stars'] ?? 0).compareTo(a['stars'] ?? 0);
    });
    // Return top 5 popular items
    return allItems.take(5).toList();
  }

  // City- and category-specific mock data
  static const Map<String, Map<String, List<Map<String, dynamic>>>>
  cityCategoryData = {
    'Douala': {
      'food_and_drinks': [
        {
          'name': 'Le Gourmet Douala',
          'image': 'assets/dataset/douala/restaurant/black and white.png',
          'stars': 4.7,
          'description': 'Fine French cuisine in Douala.',
          'likes': 120,
        },
        {
          'name': 'La Marquise',
          'image': 'assets/dataset/douala/restaurant/la marquise.png',
          'stars': 4.5,
          'description': 'Elegant dining with international cuisine.',
          'likes': 95,
        },
        {
          'name': 'Le Grilladin',
          'image': 'assets/dataset/douala/restaurant/le grilladin.png',
          'stars': 4.6,
          'description': 'Best grilled fish in town.',
          'likes': 110,
        },
        {
          'name': 'Le Keurtis',
          'image': 'assets/dataset/douala/restaurant/le keurtis.png',
          'stars': 4.4,
          'description': 'Traditional Cameroonian dishes.',
          'likes': 85,
        },
        {
          'name': 'LGM Restaurant',
          'image': 'assets/dataset/douala/restaurant/lgm(le glaier moderne.png',
          'stars': 4.3,
          'description': 'Modern restaurant with local flavors.',
          'likes': 75,
        },
        {
          'name': 'Lilas Restaurant',
          'image': 'assets/dataset/douala/restaurant/lilas.png',
          'stars': 4.5,
          'description': 'Cozy atmosphere with great food.',
          'likes': 90,
        },
        {
          'name': 'Paul Restaurant',
          'image': 'assets/dataset/douala/restaurant/paul.png',
          'stars': 4.4,
          'description': 'French-inspired cuisine.',
          'likes': 80,
        },
        {
          'name': 'The Yard',
          'image': 'assets/dataset/douala/restaurant/the yard.png',
          'stars': 4.6,
          'description': 'Outdoor dining experience.',
          'likes': 100,
        },
        {
          'name': 'Vienna Restaurant',
          'image': 'assets/dataset/douala/restaurant/vienna.png',
          'stars': 4.3,
          'description': 'European cuisine in Douala.',
          'likes': 70,
        },
        {
          'name': 'Vigna Restaurant',
          'image': 'assets/dataset/douala/restaurant/vigna.png',
          'stars': 4.5,
          'description': 'Italian-inspired dishes.',
          'likes': 88,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Best Western Douala',
          'image': 'assets/dataset/douala/hotels/best western.png',
          'stars': 4.7,
          'description': 'Luxury rooms with city views.',
          'likes': 110,
        },
        {
          'name': 'Faya Hotel',
          'image': 'assets/dataset/douala/hotels/faya hotel.png',
          'stars': 4.5,
          'description': 'Modern hotel in the business district.',
          'likes': 95,
        },
        {
          'name': 'Geneva Hotel',
          'image': 'assets/dataset/douala/hotels/geneva.png',
          'stars': 4.4,
          'description': 'Comfortable accommodation with great service.',
          'likes': 85,
        },
        {
          'name': 'Ibis Douala',
          'image': 'assets/dataset/douala/hotels/ibis.png',
          'stars': 4.6,
          'description': 'Affordable comfort in the city center.',
          'likes': 100,
        },
        {
          'name': 'Hotel K',
          'image': 'assets/dataset/douala/hotels/k.png',
          'stars': 4.3,
          'description': 'Boutique hotel with unique charm.',
          'likes': 75,
        },
        {
          'name': 'Krystal Hotel',
          'image': 'assets/dataset/douala/hotels/krystal.png',
          'stars': 4.5,
          'description': 'Luxury hotel with premium amenities.',
          'likes': 105,
        },
        {
          'name': 'Libertise Hotel',
          'image': 'assets/dataset/douala/hotels/libertise.png',
          'stars': 4.4,
          'description': 'Contemporary design and comfort.',
          'likes': 90,
        },
        {
          'name': 'Onomo Hotel',
          'image': 'assets/dataset/douala/hotels/onomo hotel.png',
          'stars': 4.6,
          'description': 'Business hotel with modern facilities.',
          'likes': 98,
        },
        {
          'name': 'Rabbingha Hotel',
          'image': 'assets/dataset/douala/hotels/rabingha.png',
          'stars': 4.3,
          'description': 'Traditional hospitality in Douala.',
          'likes': 80,
        },
        {
          'name': 'Somatel Hotel',
          'image': 'assets/dataset/douala/hotels/somatel.png',
          'stars': 4.5,
          'description': 'Reliable accommodation with good service.',
          'likes': 92,
        },
      ],
      'things_to_do': [
        {
          'name': 'Bonanjo District Tour',
          'image': 'assets/dataset/douala/activities/Bonanjo District.png',
          'stars': 4.7,
          'description': 'Explore the historic Bonanjo district.',
          'likes': 140,
        },
        {
          'name': 'Douala Cathedral',
          'image': 'assets/dataset/douala/activities/Cathedral of Saints Peter and Paul.png',
          'stars': 4.6,
          'description': 'Historic cathedral in the city center.',
          'likes': 130,
        },
        {
          'name': 'Doual\'art Gallery',
          'image': 'assets/dataset/douala/activities/Doual\'art.png',
          'stars': 4.5,
          'description': 'Contemporary art gallery and cultural center.',
          'likes': 120,
        },
        {
          'name': 'Douala-Edéa National Park',
          'image': 'assets/dataset/douala/activities/Douala-Edéa National Park.png',
          'stars': 4.8,
          'description': 'Wildlife and nature exploration.',
          'likes': 160,
        },
        {
          'name': 'Douala Night Market',
          'image': 'assets/dataset/douala/activities/marche de fleure.png',
          'stars': 4.4,
          'description': 'Street food, crafts, and live music.',
          'likes': 100,
        },
        {
          'name': 'Maritime Museum',
          'image': 'assets/dataset/douala/activities/Maritime Museum of Douala.png',
          'stars': 4.6,
          'description': 'Discover the maritime history of Douala.',
          'likes': 150,
        },
        {
          'name': 'Palace of King Bell',
          'image': 'assets/dataset/douala/activities/Palace of King Bell.png',
          'stars': 4.5,
          'description': 'Historic royal palace and cultural site.',
          'likes': 125,
        },
        {
          'name': 'Reunification Stadium',
          'image': 'assets/dataset/douala/activities/Reunification Stadium.jpg',
          'stars': 4.4,
          'description': 'Sports and entertainment venue.',
          'likes': 90,
        },
        {
          'name': 'Wouri River Tour',
          'image': 'assets/dataset/douala/activities/wouri.png',
          'stars': 4.7,
          'description': 'Guided tours through Douala neighborhoods.',
          'likes': 145,
        },
        {
          'name': 'Youpwe Fishing Town',
          'image': 'assets/dataset/douala/activities/youpwe fishing town.jpg',
          'stars': 4.5,
          'description': 'Traditional fishing village experience.',
          'likes': 115,
        },
      ],
      'touristic_sites': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding touristic sites for Douala. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
    },
    'Yaounde': {
      'food_and_drinks': [
        {
          'name': 'Brochette de Bastos',
          'image': 'assets/dataset/yaounde/restaurant/brochette de bastos.jpg',
          'stars': 4.7,
          'description': 'Famous grilled meat skewers in Bastos.',
          'likes': 105,
        },
        {
          'name': 'Chop et Yamo',
          'image': 'assets/dataset/yaounde/restaurant/chop et yamo.jpg',
          'stars': 4.5,
          'description': 'Traditional Cameroonian cuisine.',
          'likes': 95,
        },
        {
          'name': 'Chroma Restaurant',
          'image': 'assets/dataset/yaounde/restaurant/chroma restaurant.jpg',
          'stars': 4.6,
          'description': 'Modern restaurant with international menu.',
          'likes': 100,
        },
        {
          'name': 'La Paillote',
          'image': 'assets/dataset/yaounde/restaurant/la paillote.jpg',
          'stars': 4.4,
          'description': 'Cozy restaurant with local specialties.',
          'likes': 85,
        },
        {
          'name': 'Le Grillardin',
          'image': 'assets/dataset/yaounde/restaurant/le grillardin.jpg',
          'stars': 4.5,
          'description': 'Grilled specialties and fresh seafood.',
          'likes': 90,
        },
        {
          'name': 'Le Safoutier',
          'image': 'assets/dataset/yaounde/restaurant/le safoutier.jpg',
          'stars': 4.6,
          'description': 'Coffee and pastries downtown.',
          'likes': 80,
        },
        {
          'name': 'Le Salsa',
          'image': 'assets/dataset/yaounde/restaurant/le salsa.jpg',
          'stars': 4.3,
          'description': 'Latin-inspired cuisine in Yaounde.',
          'likes': 75,
        },
        {
          'name': 'Solo Restaurant',
          'image': 'assets/dataset/yaounde/restaurant/Solo.jpg',
          'stars': 4.4,
          'description': 'Intimate dining experience.',
          'likes': 88,
        },
        {
          'name': 'Steak House',
          'image': 'assets/dataset/yaounde/restaurant/steak house.jpg',
          'stars': 4.5,
          'description': 'Premium steaks and grilled meats.',
          'likes': 92,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Hilton Yaounde',
          'image': 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg',
          'stars': 4.8,
          'description': 'Luxury hotel in the heart of Yaounde.',
          'likes': 120,
        },
        {
          'name': 'Hotel La Falaise',
          'image': 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg',
          'stars': 4.6,
          'description': 'Elegant hotel with city views.',
          'likes': 110,
        },
        {
          'name': 'Hotel Merina',
          'image': 'assets/dataset/yaounde/hotels/hotel merina.jpg',
          'stars': 4.4,
          'description': 'Comfortable accommodation with great service.',
          'likes': 95,
        },
        {
          'name': 'Hôtel Mont Fébé',
          'image': 'assets/dataset/yaounde/hotels/HÔTEL MONT FÉBÉ.jpg',
          'stars': 4.5,
          'description': 'Mountain view hotel with modern amenities.',
          'likes': 100,
        },
        {
          'name': 'Isis Hotel',
          'image': 'assets/dataset/yaounde/hotels/isis hotel.jpg',
          'stars': 4.3,
          'description': 'Business hotel in central Yaounde.',
          'likes': 85,
        },
        {
          'name': 'Lafayette Hotel',
          'image': 'assets/dataset/yaounde/hotels/Lafayette Hotel.jpg',
          'stars': 4.4,
          'description': 'Historic hotel with traditional charm.',
          'likes': 90,
        },
        {
          'name': 'Le Kremlin Hotel',
          'image': 'assets/dataset/yaounde/hotels/le kremlin hotel.jpg',
          'stars': 4.5,
          'description': 'Luxury hotel with Russian-inspired design.',
          'likes': 105,
        },
        {
          'name': 'Palace Hotel',
          'image': 'assets/dataset/yaounde/hotels/Palace Hotel, Durres, Albania.jpg',
          'stars': 4.6,
          'description': 'Palatial accommodation with premium services.',
          'likes': 115,
        },
        {
          'name': 'Star Land Hotel',
          'image': 'assets/dataset/yaounde/hotels/star land hotel.jpg',
          'stars': 4.4,
          'description': 'Modern hotel with contemporary design.',
          'likes': 88,
        },
        {
          'name': 'United Hotel',
          'image': 'assets/dataset/yaounde/hotels/United Hotel.jpg',
          'stars': 4.3,
          'description': 'Reliable accommodation for business travelers.',
          'likes': 82,
        },
      ],
      'things_to_do': [
        {
          'name': 'Yaounde City Center',
          'image': 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg',
          'stars': 4.5,
          'description': 'Explore the vibrant city center of Yaounde.',
          'likes': 120,
        },
        {
          'name': 'Cultural Heritage Tour',
          'image': 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg',
          'stars': 4.6,
          'description': 'Discover Cameroonian culture and history.',
          'likes': 135,
        },
        {
          'name': 'Art and Crafts Market',
          'image': 'assets/dataset/yaounde/hotels/hotel merina.jpg',
          'stars': 4.4,
          'description': 'Local artisans and traditional crafts.',
          'likes': 95,
        },
        {
          'name': 'Mountain View Experience',
          'image': 'assets/dataset/yaounde/hotels/HÔTEL MONT FÉBÉ.jpg',
          'stars': 4.7,
          'description': 'Breathtaking views from Mont Fébé.',
          'likes': 140,
        },
        {
          'name': 'Business District Tour',
          'image': 'assets/dataset/yaounde/hotels/isis hotel.jpg',
          'stars': 4.3,
          'description': 'Explore Yaounde\'s modern business center.',
          'likes': 85,
        },
        {
          'name': 'Historic Quarter Walk',
          'image': 'assets/dataset/yaounde/hotels/Lafayette Hotel.jpg',
          'stars': 4.5,
          'description': 'Walking tour through historic neighborhoods.',
          'likes': 110,
        },
        {
          'name': 'Luxury Shopping Experience',
          'image': 'assets/dataset/yaounde/hotels/le kremlin hotel.jpg',
          'stars': 4.4,
          'description': 'High-end shopping and dining in Yaounde.',
          'likes': 100,
        },
        {
          'name': 'Palace Grounds Tour',
          'image': 'assets/dataset/yaounde/hotels/Palace Hotel, Durres, Albania.jpg',
          'stars': 4.6,
          'description': 'Explore the presidential palace area.',
          'likes': 125,
        },
        {
          'name': 'Modern Architecture Tour',
          'image': 'assets/dataset/yaounde/hotels/star land hotel.jpg',
          'stars': 4.3,
          'description': 'Contemporary buildings and modern design.',
          'likes': 88,
        },
        {
          'name': 'Business Networking Events',
          'image': 'assets/dataset/yaounde/hotels/United Hotel.jpg',
          'stars': 4.2,
          'description': 'Professional networking and business events.',
          'likes': 80,
        },
      ],
      'touristic_sites': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding touristic sites for Yaounde. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
    },
    'Kribi': {
      'food_and_drinks': [
        {
          'name': 'Kribi Beach Restaurant',
          'image': 'assets/dataset/kribi/restaurants/restokribi.jpg',
          'stars': 4.7,
          'description': 'Seafood specialties by the ocean.',
          'likes': 125,
        },
        {
          'name': 'Douala Restaurant Kribi',
          'image': 'assets/dataset/kribi/restaurants/restodla.jpg',
          'stars': 4.5,
          'description': 'Traditional Cameroonian cuisine by the sea.',
          'likes': 110,
        },
        {
          'name': 'Yde Restaurant',
          'image': 'assets/dataset/kribi/restaurants/restoyde.jpg',
          'stars': 4.6,
          'description': 'Fresh seafood and local specialties.',
          'likes': 115,
        },
        {
          'name': 'Coastal Dining',
          'image': 'assets/dataset/kribi/restaurants/download (6).jpg',
          'stars': 4.4,
          'description': 'Beachside dining with ocean views.',
          'likes': 100,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Kribi Beach Hotel',
          'image': 'assets/dataset/kribi/hotels/hotelkribi.jpg',
          'stars': 4.7,
          'description': 'Beachfront hotel with stunning ocean views.',
          'likes': 120,
        },
        {
          'name': 'Hotel Kribi',
          'image': 'assets/dataset/kribi/hotels/hotel.jpg',
          'stars': 4.5,
          'description': 'Comfortable accommodation near the beach.',
          'likes': 105,
        },
        {
          'name': 'Yde Hotel',
          'image': 'assets/dataset/kribi/hotels/hotelyde.jpg',
          'stars': 4.6,
          'description': 'Modern hotel with beach access.',
          'likes': 110,
        },
      ],
      'things_to_do': [
        {
          'name': 'Chutes de la Lobé',
          'image': 'assets/dataset/kribi/activities/chutelobekribi.jpg',
          'stars': 4.8,
          'description': 'Spectacular waterfalls flowing into the ocean.',
          'likes': 160,
        },
        {
          'name': 'Boat Tour Kribi',
          'image': 'assets/dataset/kribi/activities/boattour.jpg',
          'stars': 4.6,
          'description': 'Explore the beautiful coastline by boat.',
          'likes': 130,
        },
        {
          'name': 'Beach Activities',
          'image': 'assets/dataset/kribi/activities/download2.jpg',
          'stars': 4.5,
          'description': 'Swimming, sunbathing, and beach sports.',
          'likes': 120,
        },
      ],
      'touristic_sites': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding touristic sites for Kribi. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
    },
    'Buea': {
      'food_and_drinks': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding restaurants for Buea. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
      'places_to_stay': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding hotels for Buea. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
      'things_to_do': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding activities for Buea. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
      'touristic_sites': [
        {
          'name': 'No data available yet',
          'image': 'assets/default.jpg',
          'stars': 0.0,
          'description': 'We are working on adding touristic sites for Buea. Check back soon!',
          'likes': 0,
          'isPlaceholder': true,
        },
      ],
    },
  };

  static List<Map<String, dynamic>> getCategoryFeed(
    String city,
    String category,
  ) {
    final cityData = cityCategoryData[city];
    if (cityData != null && cityData[category] != null) {
      return cityData[category]!;
    }
    // fallback to generic samples if city/category not found
    switch (category) {
      case 'food_and_drinks':
        return [
            {
              'name': 'Le Gourmet',
              'image': 'assets/onboarding.jpeg',
              'stars': 4.7,
              'description': 'Fine French cuisine with a modern twist.',
            },
            {
              'name': 'Mama Africa',
              'image': 'assets/onboarding1.jpeg',
              'stars': 4.7,
              'description': 'Authentic African dishes in a vibrant setting.',
            },
        ];
      case 'places_to_stay':
        return [
          {
            'name': 'Grand Hotel',
            'image': 'assets/download.jpg',
            'stars': 4.7,
            'description': 'Luxury rooms with city views and a rooftop pool.',
          },
        ];
      case 'touristic_sites':
        return [
          {
            'name': 'Old Town Square',
            'image': 'assets/download1.jpg',
            'stars': 4.7,
            'description': 'Historic center with beautiful architecture.',
          },
        ];
      case 'things_to_do':
        return [
            {
              'name': 'City Walking Tour',
              'image': 'assets/onboarding.jpeg',
              'stars': 4.7,
              'description': 'Guided tours through historic neighborhoods.',
            },
        ];
      default:
        return [
          {
            'name': 'Sample Place',
            'image': 'assets/download.jpg',
            'stars': 4.7,
            'description': 'A nice place for your needs.',
          },
        ];
    }
  }
}
