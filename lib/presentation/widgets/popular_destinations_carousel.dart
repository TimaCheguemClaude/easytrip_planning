import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import 'explore_card.dart';

class PopularDestinationsCarousel extends StatelessWidget {
  final String cityName;
  const PopularDestinationsCarousel({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final destinations = MockExploreData.getPopularDestinations(cityName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            // TODO: Use intl
            'Popular Destinations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: destinations
                .map(
                  (dest) => SizedBox(
                    width: 160,
                    height: 190,
                    child: ExploreCard(item: dest),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
