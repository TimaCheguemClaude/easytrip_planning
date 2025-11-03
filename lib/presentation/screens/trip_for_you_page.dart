import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_explore_data.dart';
import '../../data/model/touristic_site.dart';
import '../../utils/trip_storage.dart';
import '../../utils/theme.dart';
import '../widgets/recommendation_card.dart';
import 'explore_card_detail_page.dart';

class TripForYouPage extends StatefulWidget {
  final Map<String, dynamic>? trip;
  const TripForYouPage({super.key, this.trip});

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
    // Use the passed trip parameter if available, otherwise fallback to first trip
    Map<String, dynamic>? trip = widget.trip;
    
    if (trip == null) {
      // Fallback: use the first trip in storage if available
      final trips = await TripStorage.listAllTrips();
      String? tripName = trips.isNotEmpty ? trips.first : null;
      if (tripName == null) {
        // Final fallback: use default values
        setState(() {
          _trip = {'city': 'Douala', 'budget': 300, 'crew': 2};
          _budget = 300;
          _crew = 2;
          _recommendations = _getRecommendationsForCity('Douala');
        });
        return;
      }
      trip = await TripStorage.getTrip(tripName);
      if (trip == null) return;
    }
    
    final city = trip['city'] ?? 'Douala';
    final budget = double.tryParse(trip['budget']?.toString() ?? '0') ?? 0;
    final crew = int.tryParse(trip['crew']?.toString() ?? '1') ?? 1;
    
    // Get recommendations for the specific city
    final recommendations = _getRecommendationsForCity(city);
    
    setState(() {
      _trip = trip;
      _budget = budget;
      _crew = crew;
      _recommendations = recommendations;
    });
  }

  List<Map<String, dynamic>> _getRecommendationsForCity(String city) {
    final List<Map<String, dynamic>> allPlaces = [];
    
    // Get all available cities from the dataset
    final availableCities = MockExploreData.cityCategoryData.keys.toList();
    
    // If the selected city is not in the dataset, use the first available city
    final targetCity = availableCities.contains(city) ? city : availableCities.first;
    
    final cityData = MockExploreData.cityCategoryData[targetCity];
    if (cityData != null) {
      for (final category in MockExploreData.categories) {
        final items = cityData[category] ?? [];
        for (var i = 0; i < items.length; i++) {
          final base = items[i];
          // Skip placeholder items
          if (base['isPlaceholder'] == true) continue;
          
          final price = 50 + ((base['stars'] + i) * 30).toInt();
          allPlaces.add({...base, 'name': base['name'], 'price': price});
        }
      }
    }
    
    // Sort by popularity (likes and stars)
    allPlaces.sort((a, b) {
      final aLikes = a['likes'] ?? 0;
      final bLikes = b['likes'] ?? 0;
      if (aLikes != bLikes) return bLikes.compareTo(aLikes);
      return (b['stars'] ?? 0).compareTo(a['stars'] ?? 0);
    });
    
    return allPlaces;
  }

  Map<String, dynamic>? _trip;
  List<Map<String, dynamic>> _recommendations = [];
  double? _budget;
  int? _crew;

  void _navigateToDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreCardDetailPage(
          item: item,
          imageUrls: [item['image'] ?? 'assets/default.jpg'],
          reviews: [],
          similarItems: _getSimilarItems(item),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSimilarItems(Map<String, dynamic> currentItem) {
    final city = _trip?['city'] ?? 'Default City';
    final categories = ['places_to_stay', 'food_and_drinks', 'things_to_do', 'touristic_sites'];
    
    for (final category in categories) {
      final categoryFeed = MockExploreData.getCategoryFeed(city, category);
      final foundItem = categoryFeed.firstWhere(
        (item) => item['name'] == currentItem['name'],
        orElse: () => <String, dynamic>{},
      );
      
      if (foundItem.isNotEmpty) {
        final similarItems = categoryFeed
            .where((item) => 
                item['name'] != currentItem['name'] && 
                item['isPlaceholder'] != true)
            .toList();
        
        similarItems.sort((a, b) {
          final aLikes = a['likes'] ?? 0;
          final bLikes = b['likes'] ?? 0;
          if (aLikes != bLikes) return bLikes.compareTo(aLikes);
          return (b['stars'] ?? 0).compareTo(a['stars'] ?? 0);
        });
        
        return similarItems.take(5).toList();
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Provider.of<UiProvider>(context); // ensure rebuild on theme change

    if (_trip == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.primaryColor),
            const SizedBox(height: 16),
            Text(
              'Loading recommendations...',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_recommendations.isEmpty) {
      final cityName = _trip?['city'] ?? 'your selected city';
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No recommendations found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No places found for $cityName.\nTry selecting a different city or check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final budgetPerPerson = (_budget ?? 0) / (_crew ?? 1);
    final cityName = _trip?['city'] ?? 'Unknown City';
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recommendations.length + 1, // +1 for header
      itemBuilder: (context, index) {
        // Header for city recommendations
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.1),
                  theme.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendations for $cityName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_recommendations.length} places found • Budget: ${budgetPerPerson.toInt()} XAF per person',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        // Adjust index for recommendations (skip header)
        final recommendationIndex = index - 1;
        final item = _recommendations[recommendationIndex];
        final price = item['price'] ?? 0;
        final isWithinBudget = price <= budgetPerPerson;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isWithinBudget 
                  ? Colors.green.withOpacity(0.3)
                  : Colors.orange.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Budget indicator
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWithinBudget ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isWithinBudget ? 'Within Budget' : 'Above Budget',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // Price indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isWithinBudget ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${price.toInt()} XAF',
                    style: TextStyle(
                      color: isWithinBudget ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // Recommendation card
              RecommendationCard(
                recommendation: Recommendation(
                  title: item['name'] ?? 'Unknown Place',
                  description: item['description'] ?? 'No description available',
                  image: item['image'] ?? 'assets/default.jpg',
                  reason: isWithinBudget 
                      ? 'Perfect for your budget!'
                      : 'Consider your budget carefully',
                ),
                onSave: () => _saveToTrip(item),
                onBook: () => _bookItem(item),
                onTap: () => _navigateToDetail(item),
                isSaved: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveToTrip(Map<String, dynamic> item) async {
    final tripName = _trip?['name'] ?? 'Default Trip';
    await TripStorage.saveCardToTrip(tripName, item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} saved to your trip'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _bookItem(Map<String, dynamic> item) {
    // Navigate to booking screen with the item
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreCardDetailPage(
          item: item,
          imageUrls: [item['image'] ?? 'assets/default.jpg'],
          reviews: [],
          similarItems: _getSimilarItems(item),
        ),
      ),
    );
  }
}
