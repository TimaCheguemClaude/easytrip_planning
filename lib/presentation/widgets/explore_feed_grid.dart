import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import '../../data/model/touristic_site.dart';
import 'recommendation_card.dart';
import '../screens/explore_card_detail_page.dart';
import '../screens/booking_screen.dart';

class ExploreFeedGrid extends StatelessWidget {
  final String cityName;
  final String category;
  
  const ExploreFeedGrid({
    super.key,
    required this.cityName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final feed = _getCategoryFeedWithDatasetImages(cityName, category);
    
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = feed[index];
            
            // Check if this is a placeholder item
            if (item['isPlaceholder'] == true) {
              return _buildPlaceholderCard(context, item);
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExploreCardDetailPage(
                        item: item,
                        imageUrls: [item['image'] ?? 'assets/default.jpg'],
                        reviews: [],
                        similarItems: _getSimilarItems(item, cityName, category),
                      ),
                    ),
                  );
                },
                child: RecommendationCard(
                  recommendation: Recommendation(
                    title: item['name'] ?? 'Unknown',
                    description: item['description'] ?? '',
                    image: item['image'] ?? 'assets/default.jpg',
                    reason: 'Discover $category in $cityName',
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
                            title: item['name'] ?? 'Unknown',
                            description: item['description'] ?? '',
                            image: item['image'] ?? 'assets/default.jpg',
                            reason: 'Discover $category in $cityName',
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
          childCount: feed.length,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getCategoryFeedWithDatasetImages(String cityName, String category) {
    // Use the new rich data from MockExploreData
    final mockFeed = MockExploreData.getCategoryFeed(cityName, category);
    
    // Return the feed with all the new images and data we just added
    return mockFeed.map((item) => {
      ...item,
      'stars': item['stars'] ?? 4.5, // Ensure stars is never null
      'likes': item['likes'] ?? 100, // Ensure likes is never null
    }).toList();
  }

  Widget _buildPlaceholderCard(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              item['name'] ?? 'No data available yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              item['description'] ?? 'We are working on adding content for this category.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Coming Soon',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSimilarItems(
    Map<String, dynamic> currentItem,
    String cityName,
    String category,
  ) {
    // Get all items from the same category in the same city
    final categoryFeed = MockExploreData.getCategoryFeed(cityName, category);
    
    // Filter out the current item and placeholder items
    final similarItems = categoryFeed
        .where((item) => 
            item['name'] != currentItem['name'] && 
            item['isPlaceholder'] != true)
        .toList();
    
    // Sort by likes (descending), then by stars (descending)
    similarItems.sort((a, b) {
      final aLikes = a['likes'] ?? 0;
      final bLikes = b['likes'] ?? 0;
      if (aLikes != bLikes) return bLikes.compareTo(aLikes);
      return (b['stars'] ?? 0).compareTo(a['stars'] ?? 0);
    });
    
    // Return minimum 2, maximum 5 items
    final count = similarItems.length;
    if (count <= 2) {
      return similarItems; // Return all if 2 or fewer
    } else if (count <= 5) {
      return similarItems; // Return all if 5 or fewer
    } else {
      return similarItems.take(5).toList(); // Return top 5
    }
  }
}