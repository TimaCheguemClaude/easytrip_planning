import 'package:flutter/material.dart';
import '../widgets/explore_card.dart';

class TripForYouPage extends StatelessWidget {
  const TripForYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock recommendations (add stars/description for ExploreCard)
    final recommendations = [
      {
        'name': 'Hidden Gem',
        'image': 'assets/download2.jpg',
        'stars': 4.6,
        'description': 'A must-see location.',
      },
      {
        'name': 'Local Market',
        'image': 'assets/download1.jpg',
        'stars': 4.2,
        'description': 'Great for local shopping.',
      },
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: recommendations.map((item) => ExploreCard(item: item)).toList(),
    );
  }
}
