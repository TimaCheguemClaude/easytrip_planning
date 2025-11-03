import 'mock_explore_data.dart';
import 'model/touristic_site.dart';

class TouristicSitesDataset {
  static final List<TouristicSite> sites = [
    // DOUALA ACTIVITIES - Based on actual dataset images
    TouristicSite(
      title: 'Bonanjo District',
      city: 'Douala',
      activities: [
        'City Tours',
        'Architecture',
        'Shopping',
        'Business District',
      ],
      price: 12000,
      image: 'assets/dataset/douala/activities/Bonanjo District.png',
      description:
          'Historic business district of Douala, featuring colonial architecture, government buildings, and commercial centers.',
    ),
    TouristicSite(
      title: 'Cathedral of Saints Peter and Paul',
      city: 'Douala',
      activities: [
        'Religious Tours',
        'Architecture',
        'Photography',
        'Cultural Learning',
      ],
      price: 5000,
      image:
          'assets/dataset/douala/activities/Cathedral of Saints Peter and Paul.png',
      description:
          'Beautiful Catholic cathedral in Douala, showcasing impressive architecture and serving as an important religious landmark.',
    ),
    TouristicSite(
      title: 'Doual\'art',
      city: 'Douala',
      activities: [
        'Art Viewing',
        'Cultural Learning',
        'Photography',
        'Contemporary Art',
      ],
      price: 8000,
      image: 'assets/dataset/douala/activities/Doual\'art.png',
      description:
          'Contemporary art center promoting African art and culture, featuring exhibitions, workshops, and cultural events.',
    ),
    TouristicSite(
      title: 'Douala-Edéa National Park',
      city: 'Douala',
      activities: [
        'Wildlife Safari',
        'Nature Walks',
        'Bird Watching',
        'Photography',
      ],
      price: 25000,
      image: 'assets/dataset/douala/activities/Douala-Edéa National Park.png',
      description:
          'Protected mangrove ecosystem near Douala, home to diverse wildlife including manatees, crocodiles, and numerous bird species.',
    ),
    TouristicSite(
      title: 'Marché de Fleurs',
      city: 'Douala',
      activities: [
        'Shopping',
        'Cultural Experience',
        'Photography',
        'Local Markets',
      ],
      price: 3000,
      image: 'assets/dataset/douala/activities/marche de fleure.png',
      description:
          'Vibrant flower market in Douala, offering beautiful local and imported flowers, plants, and gardening supplies.',
    ),
    TouristicSite(
      title: 'Maritime Museum of Douala',
      city: 'Douala',
      activities: [
        'Museum Tours',
        'Maritime History',
        'Cultural Learning',
        'Photography',
      ],
      price: 15000,
      image: 'assets/dataset/douala/activities/Maritime Museum of Douala.png',
      description:
          'Discover the rich maritime heritage of Cameroon\'s economic capital, featuring ship models, navigation instruments, and port history.',
    ),
    TouristicSite(
      title: 'Palace of King Bell',
      city: 'Douala',
      activities: [
        'Historical Tours',
        'Cultural Learning',
        'Architecture',
        'Royal Heritage',
      ],
      price: 18000,
      image: 'assets/dataset/douala/activities/Palace of King Bell.png',
      description:
          'Historic palace of the Bell dynasty, showcasing traditional Duala architecture and the history of local kingdoms.',
    ),
    TouristicSite(
      title: 'Reunification Stadium',
      city: 'Douala',
      activities: [
        'Sports Events',
        'Stadium Tours',
        'Photography',
        'Entertainment',
      ],
      price: 10000,
      image: 'assets/dataset/douala/activities/Reunification Stadium.jpg',
      description:
          'Major sports stadium in Douala, hosting football matches and cultural events, symbol of Cameroon\'s reunification.',
    ),
    TouristicSite(
      title: 'Wouri River',
      city: 'Douala',
      activities: [
        'River Cruises',
        'Boat Tours',
        'Photography',
        'Sunset Viewing',
      ],
      price: 20000,
      image: 'assets/dataset/douala/activities/wouri.png',
      description:
          'Scenic river cruise along the Wouri River, offering beautiful views of Douala\'s skyline and mangrove forests.',
    ),
    TouristicSite(
      title: 'Youpwe Fishing Town',
      city: 'Douala',
      activities: [
        'Cultural Tours',
        'Fishing Experience',
        'Local Life',
        'Photography',
      ],
      price: 15000,
      image: 'assets/dataset/douala/activities/youpwe fishing town.jpg',
      description:
          'Traditional fishing village near Douala, offering authentic cultural experiences and fresh seafood.',
    ),

    // DOUALA HOTELS - Based on actual dataset images
    TouristicSite(
      title: 'Best Western Hotel',
      city: 'Douala',
      activities: [
        'Luxury Stay',
        'Business Meetings',
        'Fine Dining',
        'Conference Facilities',
      ],
      price: 65000,
      image: 'assets/dataset/douala/hotels/best western.png',
      description:
          'International standard hotel offering comfortable accommodation and modern amenities for business and leisure travelers.',
    ),
    TouristicSite(
      title: 'Faya Hotel',
      city: 'Douala',
      activities: [
        'Accommodation',
        'Restaurant',
        'Business Services',
        'City Access',
      ],
      price: 45000,
      image: 'assets/dataset/douala/hotels/faya hotel.png',
      description:
          'Modern hotel in Douala providing comfortable rooms and convenient access to the city\'s business and entertainment districts.',
    ),
    TouristicSite(
      title: 'Geneva Hotel',
      city: 'Douala',
      activities: [
        'Luxury Stay',
        'Fine Dining',
        'Business Center',
        'Airport Transfer',
      ],
      price: 55000,
      image: 'assets/dataset/douala/hotels/geneva.png',
      description:
          'Elegant hotel offering premium services, comfortable accommodation, and easy access to Douala\'s main attractions.',
    ),
    TouristicSite(
      title: 'Ibis Hotel Douala',
      city: 'Douala',
      activities: [
        'Modern Stay',
        'Restaurant',
        'Business Services',
        'City Tours',
      ],
      price: 50000,
      image: 'assets/dataset/douala/hotels/ibis.png',
      description:
          'International chain hotel providing reliable accommodation with modern amenities and professional service.',
    ),
    TouristicSite(
      title: 'Krystal Hotel',
      city: 'Douala',
      activities: [
        'Boutique Stay',
        'Restaurant',
        'Business Center',
        'Local Access',
      ],
      price: 42000,
      image: 'assets/dataset/douala/hotels/krystal.png',
      description:
          'Boutique hotel offering personalized service and comfortable accommodation in the heart of Douala.',
    ),
    TouristicSite(
      title: 'Libertise Hotel',
      city: 'Douala',
      activities: [
        'Modern Stay',
        'Conference Rooms',
        'Restaurant',
        'Business District',
      ],
      price: 48000,
      image: 'assets/dataset/douala/hotels/libertise.png',
      description:
          'Contemporary hotel with modern facilities, perfect for business travelers and conference attendees.',
    ),
    TouristicSite(
      title: 'Onomo Hotel Douala',
      city: 'Douala',
      activities: [
        'Contemporary Stay',
        'Restaurant',
        'Business Facilities',
        'Modern Amenities',
      ],
      price: 60000,
      image: 'assets/dataset/douala/hotels/onomo hotel.png',
      description:
          'Contemporary African hotel chain offering stylish accommodation with local cultural touches and modern comfort.',
    ),
    TouristicSite(
      title: 'Rabingha Hotel',
      city: 'Douala',
      activities: [
        'Comfortable Stay',
        'Local Cuisine',
        'Business Services',
        'Cultural Access',
      ],
      price: 38000,
      image: 'assets/dataset/douala/hotels/rabingha.png',
      description:
          'Comfortable hotel offering good value accommodation with local hospitality and convenient city access.',
    ),
    TouristicSite(
      title: 'Somatel Hotel',
      city: 'Douala',
      activities: [
        'Business Hotel',
        'Conference Facilities',
        'Restaurant',
        'Professional Services',
      ],
      price: 52000,
      image: 'assets/dataset/douala/hotels/somatel.png',
      description:
          'Professional business hotel with comprehensive facilities for corporate travelers and events.',
    ),

    // DOUALA RESTAURANTS - Based on actual dataset images
    TouristicSite(
      title: 'Black and White Restaurant',
      city: 'Douala',
      activities: [
        'Fine Dining',
        'International Cuisine',
        'Business Lunch',
        'Romantic Dinner',
      ],
      price: 25000,
      image: 'assets/dataset/douala/restaurant/black and white.png',
      description:
          'Elegant restaurant offering international cuisine with sophisticated ambiance, perfect for business meetings and special occasions.',
    ),
    TouristicSite(
      title: 'La Marquise Restaurant',
      city: 'Douala',
      activities: [
        'French Cuisine',
        'Fine Dining',
        'Wine Tasting',
        'Elegant Atmosphere',
      ],
      price: 35000,
      image: 'assets/dataset/douala/restaurant/la marquise.png',
      description:
          'Upscale French restaurant offering authentic cuisine, extensive wine selection, and refined dining experience.',
    ),
    TouristicSite(
      title: 'Le Grilladin',
      city: 'Douala',
      activities: [
        'Grilled Specialties',
        'Local Cuisine',
        'Casual Dining',
        'Family Friendly',
      ],
      price: 18000,
      image: 'assets/dataset/douala/restaurant/le grilladin.png',
      description:
          'Popular grill restaurant specializing in grilled meats, fish, and traditional Cameroonian dishes in a casual setting.',
    ),
    TouristicSite(
      title: 'Le Keurtis Restaurant',
      city: 'Douala',
      activities: [
        'Local Cuisine',
        'Cultural Dining',
        'Traditional Food',
        'Authentic Experience',
      ],
      price: 20000,
      image: 'assets/dataset/douala/restaurant/le keurtis.png',
      description:
          'Authentic Cameroonian restaurant serving traditional dishes in a cultural setting with local music and atmosphere.',
    ),
    TouristicSite(
      title: 'Le Glacier Moderne',
      city: 'Douala',
      activities: ['Ice Cream', 'Desserts', 'Family Treats', 'Casual Dining'],
      price: 8000,
      image: 'assets/dataset/douala/restaurant/lgm(le glaier moderne.png',
      description:
          'Popular ice cream parlor and dessert shop, perfect for families and sweet treats in Douala.',
    ),
    TouristicSite(
      title: 'Lilas Restaurant',
      city: 'Douala',
      activities: [
        'Contemporary Dining',
        'International Menu',
        'Stylish Atmosphere',
        'Social Dining',
      ],
      price: 22000,
      image: 'assets/dataset/douala/restaurant/lilas.png',
      description:
          'Stylish restaurant offering contemporary cuisine with international influences and modern atmosphere.',
    ),
    TouristicSite(
      title: 'Paul Restaurant',
      city: 'Douala',
      activities: ['French Bakery', 'Pastries', 'Coffee', 'Light Meals'],
      price: 12000,
      image: 'assets/dataset/douala/restaurant/paul.png',
      description:
          'French bakery and café offering fresh pastries, coffee, and light meals in a Parisian-style setting.',
    ),
    TouristicSite(
      title: 'The Yard Restaurant',
      city: 'Douala',
      activities: [
        'Contemporary Dining',
        'Outdoor Seating',
        'International Menu',
        'Social Atmosphere',
      ],
      price: 22000,
      image: 'assets/dataset/douala/restaurant/the yard.png',
      description:
          'Modern restaurant with outdoor seating, offering contemporary cuisine and a vibrant social atmosphere.',
    ),
    TouristicSite(
      title: 'Vienna Restaurant',
      city: 'Douala',
      activities: [
        'European Cuisine',
        'Fine Dining',
        'Elegant Setting',
        'Wine Selection',
      ],
      price: 28000,
      image: 'assets/dataset/douala/restaurant/vienna.png',
      description:
          'Elegant European restaurant offering refined cuisine with Austrian influences and excellent wine selection.',
    ),
    TouristicSite(
      title: 'Vigna Restaurant',
      city: 'Douala',
      activities: [
        'Italian Cuisine',
        'Wine Bar',
        'Romantic Dining',
        'Mediterranean Food',
      ],
      price: 30000,
      image: 'assets/dataset/douala/restaurant/vigna.png',
      description:
          'Authentic Italian restaurant with extensive wine selection, perfect for romantic dinners and Mediterranean cuisine lovers.',
    ),

    // YAOUNDE HOTELS - Based on actual dataset images
    TouristicSite(
      title: 'Hilton Yaounde',
      city: 'Yaounde',
      activities: [
        'Luxury Stay',
        'Business Center',
        'Spa Services',
        'Fine Dining',
      ],
      price: 95000,
      image: 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg',
      description:
          'Premium international hotel offering world-class amenities, luxury accommodation, and exceptional service in Cameroon\'s capital.',
    ),
    TouristicSite(
      title: 'Hotel La Falaise',
      city: 'Yaounde',
      activities: [
        'Boutique Stay',
        'Restaurant',
        'City Views',
        'Business Services',
      ],
      price: 55000,
      image: 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg',
      description:
          'Charming boutique hotel offering personalized service, comfortable rooms, and beautiful views of Yaounde.',
    ),
    TouristicSite(
      title: 'Hotel Merina',
      city: 'Yaounde',
      activities: [
        'Comfortable Stay',
        'Local Cuisine',
        'Business Facilities',
        'Cultural Access',
      ],
      price: 40000,
      image: 'assets/dataset/yaounde/hotels/hotel merina.jpg',
      description:
          'Well-located hotel providing comfortable accommodation with easy access to Yaounde\'s cultural and business districts.',
    ),
    TouristicSite(
      title: 'Hôtel Mont Fébé',
      city: 'Yaounde',
      activities: [
        'Luxury Resort',
        'Spa Services',
        'Golf Course',
        'Panoramic Views',
      ],
      price: 85000,
      image: 'assets/dataset/yaounde/hotels/HÔTEL MONT FÉBÉ.jpg',
      description:
          'Luxury hilltop resort offering spectacular views of Yaounde, world-class spa, golf course, and premium amenities.',
    ),
    TouristicSite(
      title: 'Isis Hotel',
      city: 'Yaounde',
      activities: [
        'Modern Stay',
        'Business Center',
        'Restaurant',
        'Conference Rooms',
      ],
      price: 48000,
      image: 'assets/dataset/yaounde/hotels/isis hotel.jpg',
      description:
          'Modern business hotel with comprehensive facilities for corporate travelers and conference attendees.',
    ),
    TouristicSite(
      title: 'Lafayette Hotel',
      city: 'Yaounde',
      activities: [
        'Business Hotel',
        'Conference Facilities',
        'Restaurant',
        'City Center',
      ],
      price: 50000,
      image: 'assets/dataset/yaounde/hotels/Lafayette Hotel.jpg',
      description:
          'Central business hotel offering modern facilities, conference rooms, and convenient access to government and business areas.',
    ),
    TouristicSite(
      title: 'Le Kremlin Hotel',
      city: 'Yaounde',
      activities: [
        'Luxury Stay',
        'Fine Dining',
        'Business Services',
        'Premium Amenities',
      ],
      price: 70000,
      image: 'assets/dataset/yaounde/hotels/le kremlin hotel.jpg',
      description:
          'Luxury hotel offering premium accommodation with elegant design and comprehensive business facilities.',
    ),
    TouristicSite(
      title: 'Palace Hotel',
      city: 'Yaounde',
      activities: [
        'Luxury Stay',
        'Royal Treatment',
        'Fine Dining',
        'Premium Services',
      ],
      price: 80000,
      image: 'assets/dataset/yaounde/hotels/Palace Hotel, Durres, Albania.jpg',
      description:
          'Prestigious palace hotel offering royal treatment with luxury accommodation and exceptional service standards.',
    ),
    TouristicSite(
      title: 'Star Land Hotel',
      city: 'Yaounde',
      activities: [
        'Modern Stay',
        'Entertainment',
        'Restaurant',
        'Business Center',
      ],
      price: 45000,
      image: 'assets/dataset/yaounde/hotels/star land hotel.jpg',
      description:
          'Contemporary hotel with entertainment facilities, modern amenities, and convenient business services.',
    ),
    TouristicSite(
      title: 'United Hotel',
      city: 'Yaounde',
      activities: [
        'Business Hotel',
        'Conference Rooms',
        'Restaurant',
        'Professional Services',
      ],
      price: 52000,
      image: 'assets/dataset/yaounde/hotels/United Hotel.jpg',
      description:
          'Professional business hotel with comprehensive conference facilities and reliable corporate services.',
    ),

    // YAOUNDE RESTAURANTS - Based on actual dataset images
    TouristicSite(
      title: 'Brochette de Bastos',
      city: 'Yaounde',
      activities: [
        'Grilled Specialties',
        'Local Atmosphere',
        'Traditional Food',
        'Casual Dining',
      ],
      price: 15000,
      image: 'assets/dataset/yaounde/restaurant/brochette de bastos.jpg',
      description:
          'Popular local restaurant in Bastos district, famous for grilled meat skewers and traditional Cameroonian dishes.',
    ),
    TouristicSite(
      title: 'Chop et Yamo',
      city: 'Yaounde',
      activities: [
        'Local Cuisine',
        'Street Food',
        'Cultural Experience',
        'Affordable Dining',
      ],
      price: 8000,
      image: 'assets/dataset/yaounde/restaurant/chop et yamo.jpg',
      description:
          'Authentic local eatery serving traditional Cameroonian street food and local specialties at affordable prices.',
    ),
    TouristicSite(
      title: 'Chroma Restaurant',
      city: 'Yaounde',
      activities: [
        'Contemporary Dining',
        'International Cuisine',
        'Modern Atmosphere',
        'Creative Menu',
      ],
      price: 28000,
      image: 'assets/dataset/yaounde/restaurant/chroma restaurant.jpg',
      description:
          'Modern restaurant offering creative international cuisine with contemporary design and innovative menu options.',
    ),
    TouristicSite(
      title: 'La Paillote',
      city: 'Yaounde',
      activities: [
        'Traditional Setting',
        'Local Cuisine',
        'Cultural Atmosphere',
        'Authentic Experience',
      ],
      price: 20000,
      image: 'assets/dataset/yaounde/restaurant/la paillote.jpg',
      description:
          'Traditional restaurant with authentic Cameroonian atmosphere, serving local dishes in a cultural setting.',
    ),
    TouristicSite(
      title: 'Le Grillardin',
      city: 'Yaounde',
      activities: [
        'Grilled Specialties',
        'Meat Dishes',
        'Casual Dining',
        'Local Favorites',
      ],
      price: 18000,
      image: 'assets/dataset/yaounde/restaurant/le grillardin.jpg',
      description:
          'Popular grill house specializing in perfectly grilled meats and local favorites in a casual atmosphere.',
    ),
    TouristicSite(
      title: 'Le Safoutier',
      city: 'Yaounde',
      activities: [
        'Fine Dining',
        'Local Specialties',
        'Elegant Setting',
        'Cultural Cuisine',
      ],
      price: 32000,
      image: 'assets/dataset/yaounde/restaurant/le safoutier.jpg',
      description:
          'Upscale restaurant specializing in refined Cameroonian cuisine, named after the traditional safou fruit.',
    ),
    TouristicSite(
      title: 'Le Salsa',
      city: 'Yaounde',
      activities: ['Latin Cuisine', 'Dancing', 'Entertainment', 'Nightlife'],
      price: 25000,
      image: 'assets/dataset/yaounde/restaurant/le salsa.jpg',
      description:
          'Vibrant Latin restaurant with dancing, entertainment, and authentic Latin American cuisine and atmosphere.',
    ),
    TouristicSite(
      title: 'Solo Restaurant',
      city: 'Yaounde',
      activities: [
        'Contemporary Dining',
        'International Menu',
        'Modern Setting',
        'Quality Service',
      ],
      price: 24000,
      image: 'assets/dataset/yaounde/restaurant/Solo.jpg',
      description:
          'Contemporary restaurant offering international cuisine with modern presentation and quality service.',
    ),
    TouristicSite(
      title: 'Steak House',
      city: 'Yaounde',
      activities: [
        'Steak Specialties',
        'Premium Meat',
        'Fine Dining',
        'Wine Pairing',
      ],
      price: 35000,
      image: 'assets/dataset/yaounde/restaurant/steak house.jpg',
      description:
          'Premium steak house offering the finest cuts of meat with expert preparation and excellent wine selection.',
    ),

    // ADDITIONAL SITES FROM EXISTING ASSETS
    TouristicSite(
      title: 'Chutes de la Lobé',
      city: 'Kribi',
      activities: [
        'Waterfall Viewing',
        'Swimming',
        'Photography',
        'Nature Walks',
      ],
      price: 10000,
      image: 'assets/dataset/kribi/activities/chutelobekribi.jpg',
      description:
          'Spectacular waterfalls that flow directly into the Atlantic Ocean. One of Cameroon\'s most photographed natural wonders.',
    ),
    TouristicSite(
      title: 'Kribi Beach Resort',
      city: 'Kribi',
      activities: [
        'Beach Relaxation',
        'Swimming',
        'Water Sports',
        'Sunbathing',
      ],
      price: 45000,
      image: 'assets/dataset/kribi/hotels/hotelkribi.jpg',
      description:
          'Pristine beachfront resort with white sandy beaches, crystal clear waters, and various water sports activities.',
    ),
    TouristicSite(
      title: 'Mount Cameroon Hiking',
      city: 'Buea',
      activities: [
        'Mountain Climbing',
        'Hiking',
        'Adventure Sports',
        'Photography',
      ],
      price: 75000,
      image: 'assets/download1.jpg',
      description:
          'Challenge yourself with a climb up West Africa\'s highest peak (4,095m). Guided tours available for all skill levels.',
    ),
  ];

  static List<String> getAllCities() {
    return sites.map((site) => site.city).toSet().toList()..sort();
  }

  static List<String> getAllActivities() {
    final activities = <String>{};
    for (final site in sites) {
      activities.addAll(site.activities);
    }
    return activities.toList()..sort();
  }

  static List<TouristicSite> getSitesByCity(String city) {
    return sites
        .where((site) => site.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  static List<TouristicSite> getSitesByActivity(String activity) {
    return sites
        .where(
          (site) => site.activities.any(
            (a) => a.toLowerCase().contains(activity.toLowerCase()),
          ),
        )
        .toList();
  }

  // Convert existing MockExploreData to TouristicSite format
  static List<TouristicSite> getFromExistingData() {
    final List<TouristicSite> convertedSites = [];

    for (final cityEntry in MockExploreData.cityCategoryData.entries) {
      final city = cityEntry.key;
      final categories = cityEntry.value;

      for (final categoryEntry in categories.entries) {
        final category = categoryEntry.key;
        final items = categoryEntry.value;

        for (final item in items) {
          final activities = _getActivitiesForCategory(category);
          final price = _getPriceForCategory(category);

          convertedSites.add(
            TouristicSite(
              title: item['name'] ?? 'Unknown',
              city: city,
              activities: activities,
              price: price,
              image: item['image'] ?? 'assets/default.jpg',
              description: item['description'] ?? 'No description available',
            ),
          );
        }
      }
    }

    return convertedSites;
  }

  static List<String> _getActivitiesForCategory(String category) {
    switch (category) {
      case 'food_and_drinks':
        return ['Dining', 'Food Tasting', 'Cultural Experience'];
      case 'places_to_stay':
        return ['Accommodation', 'Relaxation', 'Luxury Stay'];
      case 'touristic_sites':
        return ['Sightseeing', 'Photography', 'Cultural Learning', 'History'];
      case 'things_to_do':
        return ['Activities', 'Entertainment', 'Adventure', 'Exploration'];
      default:
        return ['General Activity'];
    }
  }

  static double _getPriceForCategory(String category) {
    switch (category) {
      case 'food_and_drinks':
        return 15000;
      case 'places_to_stay':
        return 50000;
      case 'touristic_sites':
        return 8000;
      case 'things_to_do':
        return 20000;
      default:
        return 10000;
    }
  }

  // Get all sites including existing data
  static List<TouristicSite> getAllSites() {
    final allSites = List<TouristicSite>.from(sites);
    final existingData = getFromExistingData();

    // Avoid duplicates by checking titles
    for (final existingSite in existingData) {
      final isDuplicate = allSites.any(
        (site) => site.title.toLowerCase() == existingSite.title.toLowerCase(),
      );
      if (!isDuplicate) {
        allSites.add(existingSite);
      }
    }

    return allSites;
  }

  // Get cities from all sources
  static List<String> getAllCitiesIncludingExisting() {
    final allSites = getAllSites();
    return allSites.map((site) => site.city).toSet().toList()..sort();
  }

  // Get activities from all sources
  static List<String> getAllActivitiesIncludingExisting() {
    final allSites = getAllSites();
    final activities = <String>{};
    for (final site in allSites) {
      activities.addAll(site.activities);
    }
    return activities.toList()..sort();
  }
}
