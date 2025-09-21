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
          'image': 'assets/restodla.jpg',
          'stars': 4.7,
          'description': 'Fine French cuisine in Douala.',
          'likes': 120,
        },
        {
          'name': 'Douala Grill',
          'image': 'assets/restodla.jpg',
          'stars': 4.5,
          'description': 'Best grilled fish in town.',
          'likes': 95,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Grand Hotel Douala',
          'image': 'assets/hoteldla.jpg',
          'stars': 4.6,
          'description': 'Luxury rooms with city views.',
          'likes': 110,
        },
        {
          'name': 'Budget Inn Douala',
          'image': 'assets/hoteldla.jpg',
          'stars': 4.0,
          'description': 'Affordable comfort in the city center.',
          'likes': 60,
        },
      ],
      'touristic_sites': [
        {
          'name': 'Douala Maritime Museum',
          'image': 'assets/boatdla.jpg',
          'stars': 4.9,
          'description': 'Discover the maritime history of Douala.',
          'likes': 150,
        },
        {
          'name': 'Douala Cathedral',
          'image': 'assets/chutelobekribi.jpg',
          'stars': 4.7,
          'description': 'Historic cathedral in the city center.',
          'likes': 130,
        },
      ],
      'things_to_do': [
        {
          'name': 'Douala City Tour',
          'image': 'assets/motoryde.jpg',
          'stars': 4.7,
          'description': 'Guided tours through Douala neighborhoods.',
          'likes': 140,
        },
        {
          'name': 'Douala Night Market',
          'image': 'assets/boatdla.jpg',
          'stars': 4.5,
          'description': 'Street food, crafts, and live music.',
          'likes': 100,
        },
      ],
    },
    'Yaounde': {
      'food_and_drinks': [
        {
          'name': 'Yaounde Bistro',
          'image': 'assets/restoyde.jpg',
          'stars': 4.6,
          'description': 'Trendy bistro in Yaounde.',
          'likes': 105,
        },
        {
          'name': 'Central Café',
          'image': 'assets/restoyde.jpg',
          'stars': 4.4,
          'description': 'Coffee and pastries downtown.',
          'likes': 80,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Yaounde Palace Hotel',
          'image': 'assets/hotelyde.jpg',
          'stars': 4.7,
          'description': 'Elegant hotel in Yaounde.',
          'likes': 115,
        },
      ],
      'touristic_sites': [
        {
          'name': 'Yaounde National Museum',
          'image': 'assets/motoryde.jpg',
          'stars': 4.8,
          'description': 'Explore Cameroonian history.',
          'likes': 135,
        },
      ],
      'things_to_do': [
        {
          'name': 'Yaounde Art Walk',
          'image': 'assets/motoryde.jpg',
          'stars': 4.5,
          'description': 'Discover local artists and galleries.',
          'likes': 90,
        },
      ],
    },
    'Kribi': {
      'food_and_drinks': [
        {
          'name': 'Kribi Beach Restaurant',
          'image': 'assets/restokribi.jpg',
          'stars': 4.8,
          'description': 'Seafood specialties by the ocean.',
          'likes': 125,
        },
        {
          'name': 'Kribi Grill',
          'image': 'assets/restokribi.jpg',
          'stars': 4.5,
          'description': 'Grilled fish and local cuisine.',
          'likes': 100,
        },
      ],
      'places_to_stay': [
        {
          'name': 'Kribi Beach Hotel',
          'image': 'assets/hotelkribi.jpg',
          'stars': 4.7,
          'description': 'Beachfront hotel with stunning views.',
          'likes': 120,
        },
      ],
      'touristic_sites': [
        {
          'name': 'Kribi Lighthouse',
          'image': 'assets/boatdla.jpg',
          'stars': 4.6,
          'description': 'Historic lighthouse by the sea.',
          'likes': 110,
        },
      ],
      'things_to_do': [
        {
          'name': 'Chutes de la Lobé',
          'image': 'assets/chutelobekribi.jpg',
          'stars': 4.9,
          'description': 'Spectacular waterfalls flowing into the ocean.',
          'likes': 160,
        },
        {
          'name': 'Boat Tour',
          'image': 'assets/boatdla.jpg',
          'stars': 4.7,
          'description': 'Explore the coast by boat.',
          'likes': 115,
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
            'stars': 4.5,
            'description': 'Authentic African dishes in a vibrant setting.',
          },
        ];
      case 'places_to_stay':
        return [
          {
            'name': 'Grand Hotel',
            'image': 'assets/download.jpg',
            'stars': 4.6,
            'description': 'Luxury rooms with city views and a rooftop pool.',
          },
        ];
      case 'touristic_sites':
        return [
          {
            'name': 'Old Town Square',
            'image': 'assets/download1.jpg',
            'stars': 4.9,
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
            'stars': 4.2,
            'description': 'A nice place for your needs.',
          },
        ];
    }
  }
}
