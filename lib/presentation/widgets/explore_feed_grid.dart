import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import 'explore_card.dart';

class ExploreFeedGrid extends StatelessWidget {
  final String cityName;
  final String category;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  const ExploreFeedGrid({
    super.key,
    required this.cityName,
    required this.category,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final feed = MockExploreData.getCategoryFeed(cityName, category);
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: feed.map((item) => ExploreCard(item: item)).toList(),
    );
  }
}
