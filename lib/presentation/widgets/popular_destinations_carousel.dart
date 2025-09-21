import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import 'explore_card.dart';

class PopularDestinationsCarousel extends StatelessWidget {
  final String cityName;
  const PopularDestinationsCarousel({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final destinations = MockExploreData.getPopularDestinations(cityName);

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: destinations
                  .map(
                    (dest) => Container(
                      width: 170,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: ExploreCard(item: dest),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
