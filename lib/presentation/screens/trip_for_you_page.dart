import 'package:flutter/material.dart';

import '../../data/mock_explore_data.dart';
import '../../utils/trip_storage.dart';
import '../widgets/explore_card.dart';

class TripForYouPage extends StatefulWidget {
  const TripForYouPage({super.key});

  @override
  State<TripForYouPage> createState() => _TripForYouPageState();
}

class _TripForYouPageState extends State<TripForYouPage> {
  @override
  void initState() {
    super.initState();
    _loadTripAndRecommendations();
  }

  Future<void> _loadTripAndRecommendations() async {
    // For demo, just use the first trip in storage if available
    final trips = await TripStorage.listAllTrips();
    String? tripName = trips.isNotEmpty ? trips.first : null;
    if (tripName == null) {
      // Fallback: use default values
      setState(() {
        _trip = {'city': 'Default City', 'budget': 300, 'crew': 2};
        _budget = 300;
        _crew = 2;
        _recommendations = List.generate(10, (i) {
          final base =
              MockExploreData.getCategoryFeed(
                'Default City',
                'things_to_do',
              )[i %
                  MockExploreData.getCategoryFeed(
                    'Default City',
                    'things_to_do',
                  ).length];
          final price = 50 + ((base['stars'] + i) * 30).toInt();
          return {...base, 'name': base['name'] + ' #${i + 1}', 'price': price};
        });
      });
      return;
    }
    final trip = await TripStorage.getTrip(tripName);
    if (trip == null) return;
    final city = trip['city'] ?? 'Default City';
    final budget = double.tryParse(trip['budget']?.toString() ?? '0') ?? 0;
    final crew = int.tryParse(trip['crew']?.toString() ?? '1') ?? 1;
    // Aggregate all items from all categories for the selected city
    final cityData = MockExploreData.cityCategoryData[city];
    final List<Map<String, dynamic>> allPlaces = [];
    if (cityData != null) {
      for (final category in MockExploreData.categories) {
        final items = cityData[category] ?? [];
        for (var i = 0; i < items.length; i++) {
          final base = items[i];
          final price = 50 + ((base['stars'] + i) * 30).toInt();
          allPlaces.add({...base, 'name': base['name'], 'price': price});
        }
      }
    }
    setState(() {
      _trip = trip;
      _budget = budget;
      _crew = crew;
      _recommendations = allPlaces;
    });
  }

  Map<String, dynamic>? _trip;
  List<Map<String, dynamic>> _recommendations = [];
  double? _budget;
  int? _crew;

  @override
  Widget build(BuildContext context) {
    if (_trip == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_recommendations.isEmpty) {
      return const Center(
        child: Text('No recommendations found for your preferences.'),
      );
    }
    final budgetPerPerson = (_budget ?? 0) / (_crew ?? 1);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _recommendations.map((item) {
        final price = item['price'] ?? 0;
        final isWithinBudget = price <= budgetPerPerson;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isWithinBudget ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isWithinBudget ? Colors.green : Colors.orange,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Move label to left so it doesn't hide the save button
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isWithinBudget ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isWithinBudget ? 'Within Budget' : 'Above Budget',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ExploreCard(item: item),
              Positioned(
                bottom: 8,
                right: 8,
                child: Text(
                  'Price: ${price} XAF',
                  style: TextStyle(
                    color: isWithinBudget
                        ? Colors.green[900]
                        : Colors.orange[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
