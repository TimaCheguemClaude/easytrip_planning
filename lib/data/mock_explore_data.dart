// Mock data for explore city page
class MockExploreData {
  static const List<String> categories = [
    'places_to_stay',
    'food_and_drinks',
    'things_to_do',
    'touristic_sites',
  ];

  static List<Map<String, dynamic>> getPopularDestinations(String city) => [
    {
      'name': 'Central Park',
      'image': 'assets/download.jpg',
      'stars': 4.5,
      'description': 'A beautiful park in the heart of the city.',
    },
    {
      'name': 'City Museum',
      'image': 'assets/download1.jpg',
      'stars': 4.7,
      'description': 'Discover the history and culture.',
    },
    {
      'name': 'Beach Resort',
      'image': 'assets/download2.jpg',
      'stars': 4.3,
      'description': 'Relax by the sea with great amenities.',
    },
  ];

  static List<Map<String, dynamic>> getCategoryFeed(
    String city,
    String category,
  ) => [
    {
      'name': 'Sample Place',
      'image': 'assets/download.jpg',
      'stars': 4.2,
      'description': 'A nice place for your needs.',
    },
    {
      'name': 'Another Place',
      'image': 'assets/download1.jpg',
      'stars': 4.0,
      'description': 'Great for families and groups.',
    },
    {
      'name': 'Fun Spot',
      'image': 'assets/download2.jpg',
      'stars': 4.8,
      'description': 'Top rated by visitors.',
    },
    {
      'name': 'Hidden Gem',
      'image': 'assets/download1.jpg',
      'stars': 4.6,
      'description': 'A must-see location.',
    },
  ];
}
