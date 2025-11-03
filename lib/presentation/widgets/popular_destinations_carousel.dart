import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import '../../data/touristic_sites_dataset.dart';
import 'recommendation_card.dart';
import '../../data/model/touristic_site.dart';
import '../screens/explore_card_detail_page.dart';
import '../screens/booking_screen.dart';

class PopularDestinationsCarousel extends StatelessWidget {
  final String cityName;
  const PopularDestinationsCarousel({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final destinations = _getPopularDestinationsWithDatasetImages(cityName);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Destinations',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 360, // Further increased height to prevent overflow
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final dest = destinations[index];
                return SizedBox(
                  width: 280, // Increased width for better card proportions
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreCardDetailPage(
                            item: dest,
                            imageUrls: [dest['image'] ?? 'assets/default.jpg'],
                            reviews: [],
                            similarItems: [],
                          ),
                        ),
                      );
                    },
                    child: RecommendationCard(
                      recommendation: Recommendation(
                        title: dest['name'] ?? 'Unknown',
                        description: dest['description'] ?? '',
                        image: dest['image'] ?? 'assets/default.jpg',
                        reason: 'Popular destination in $cityName',
                      ),
                      onSave: () async {
                        // Handle save functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to favorites!')),
                        );
                      },
                      onBook: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              recommendation: Recommendation(
                                title: dest['name'] ?? 'Unknown',
                                description: dest['description'] ?? '',
                                image: dest['image'] ?? 'assets/default.jpg',
                                reason: 'Popular destination in $cityName',
                              ),
                            ),
                          ),
                        );
                      },
                      isSaved: false,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 16),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPopularDestinationsWithDatasetImages(String cityName) {
    final mockDestinations = MockExploreData.getPopularDestinations(cityName);
    final datasetSites = TouristicSitesDataset.getSitesByCity(cityName);
    
    // Use dataset images if available, otherwise fallback to mock data
    if (datasetSites.isNotEmpty) {
      return datasetSites.take(6).map((site) => {
        'name': site.title,
        'description': site.description,
        'image': site.image,
        'city': cityName,
        'stars': 4 + (site.price / 10000).round().clamp(0, 1), // Generate stars based on price
        'activities': site.activities,
      }).toList();
    }
    
    // Fallback for cities without dataset (Kribi, Buea)
    return mockDestinations.map((dest) => {
      ...dest,
      'image': _getFallbackImageForCity(cityName),
    }).toList();
  }

  String _getFallbackImageForCity(String cityName) {
    switch (cityName.toLowerCase()) {
      case 'kribi':
        return 'assets/dataset/kribi/activities/chutelobekribi.jpg';
      case 'buea':
        return 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg';
      case 'douala':
        return 'assets/dataset/douala/activities/wouri.png';
      case 'yaounde':
        return 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg';
      default:
        return 'assets/default.jpg';
    }
  }
}
