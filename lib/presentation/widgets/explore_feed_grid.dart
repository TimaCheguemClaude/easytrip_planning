import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import 'explore_card.dart';

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
    final feed = MockExploreData.getCategoryFeed(cityName, category);
    
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7, // Reduced to prevent overflow
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => ExploreCard(item: feed[index]),
        childCount: feed.length,
      ),
    );
  }
}