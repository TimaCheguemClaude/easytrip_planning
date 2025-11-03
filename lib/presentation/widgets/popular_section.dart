import 'package:easytrip/data/mock_explore_data.dart';
import 'package:flutter/material.dart';

import 'recommendation_card.dart';
import '../../data/model/touristic_site.dart';
import '../screens/explore_card_detail_page.dart';
import '../screens/booking_screen.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({
    super.key,
    required this.likedItems,
    required this.commentCounts,
    required this.onComment,
    this.onSave,
    this.horizontal = false,
    this.maxItems,
  });

  final ValueNotifier<Set<String>> likedItems;
  final ValueNotifier<Map<String, int>> commentCounts;
  final void Function(String id) onComment;
  final Future<void> Function(Map<String, dynamic> cardData)? onSave;
  final bool horizontal;
  final int? maxItems;

  List<Map<String, dynamic>> _getBaseFiltered() {
    // Merge top popular from multiple cities using base rule: sort by likes desc then stars
    final cities = MockExploreData.cityCategoryData.keys;
    final merged = <Map<String, dynamic>>[];
    for (final city in cities) {
      merged.addAll(MockExploreData.getPopularDestinations(city));
    }
    // De-dup by name
    final seen = <String>{};
    final unique = <Map<String, dynamic>>[];
    for (final item in merged) {
      final name = (item['name'] ?? '').toString();
      if (name.isEmpty || seen.contains(name)) continue;
      seen.add(name);
      unique.add(item);
    }
    return unique.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    var items = _getBaseFiltered();
    if (maxItems != null && maxItems! < items.length) {
      items = items.take(maxItems!).toList();
    }
    if (horizontal) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 400, // Significantly increased height to accommodate full card content
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: 300, // Increased width for better card proportions
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreCardDetailPage(
                          item: item,
                          imageUrls: [item['image'] ?? 'assets/default.jpg'],
                          reviews: [],
                          similarItems: [],
                        ),
                      ),
                    );
                  },
                  child: RecommendationCard(
                    recommendation: Recommendation(
                      title: item['name'] ?? 'Unknown',
                      description: item['description'] ?? '',
                      image: item['image'] ?? 'assets/default.jpg',
                      reason: 'Popular destination in Cameroon',
                    ),
                    onSave: () async {
                      if (onSave != null) {
                        await onSave!(item);
                      }
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
                              reason: 'Popular destination in Cameroon',
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
            separatorBuilder: (_, __) => const SizedBox(width: 20),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
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
                        similarItems: [],
                      ),
                    ),
                  );
                },
                child: RecommendationCard(
                  recommendation: Recommendation(
                    title: item['name'] ?? 'Unknown',
                    description: item['description'] ?? '',
                    image: item['image'] ?? 'assets/default.jpg',
                    reason: 'Popular destination in Cameroon',
                  ),
                  onSave: () async {
                    if (onSave != null) {
                      await onSave!(item);
                    }
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
                            reason: 'Popular destination in Cameroon',
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
          childCount: items.length,
        ),
      ),
    );
  }
}



