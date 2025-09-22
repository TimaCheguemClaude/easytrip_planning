import 'package:easytrip/presentation/widgets/custom_loader.dart';
import 'package:easytrip/presentation/widgets/save_to_trip_dialog.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/utils/trip_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/model/touristic_site.dart';
import '../../data/touristic_sites_dataset.dart';
import '../../services/ai_recommendation_service.dart';
import '../../services/storage_service.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/trip_input_dialog.dart';
import 'booking_screen.dart';

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({super.key});

  @override
  State<AIRecommendationsScreen> createState() => _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  List<Recommendation> _recommendations = [];
  List<Recommendation> _savedRecommendations = [];
  bool _isLoading = false;
  String? _errorMessage;
  final AIRecommendationService _aiService = AIRecommendationService();

  @override
  void initState() {
    super.initState();
    _loadSavedRecommendations();
  }

  Future<void> _loadSavedRecommendations() async {
    final saved = await StorageService.getSavedRecommendations();
    setState(() {
      _savedRecommendations = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Travel Recommendations'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _savedRecommendations.isNotEmpty,
              label: Text('${_savedRecommendations.length}'),
              child: const Icon(Icons.bookmark_outlined),
            ),
            onPressed: _showSavedRecommendations,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTripInputDialog,
        icon: const Icon(Icons.smart_toy),
        label: const Text('Get AI Recommendations'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoader(size: 48),
            SizedBox(height: 16),
            Text('Getting AI recommendations...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to AI Travel Recommendations!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the button below to get personalized\ntravel recommendations powered by AI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available destinations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TouristicSitesDataset.getAllCitiesIncludingExisting()
                  .map((city) => Chip(label: Text(city)))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = _recommendations[index];
        return RecommendationCard(
          recommendation: recommendation,
          onSave: () => _saveRecommendation(recommendation),
          onBook: () => _bookRecommendation(recommendation),
        );
      },
    );
  }

  void _showTripInputDialog() {
    showDialog(
      context: context,
      builder: (context) => TripInputDialog(
        onSubmit: _getRecommendations,
      ),
    );
  }

  Future<void> _getRecommendations(UserPreferences preferences) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recommendations = [];
    });

    try {
      final recommendations = await _aiService.getRecommendations(preferences);
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });

      if (recommendations.isNotEmpty) {
        _showSuccessSnackBar('Found ${recommendations.length} recommendations for you!');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecommendation(Recommendation recommendation) async {
    try {
      // Use existing trip storage system
      final trips = await TripStorage.listAllTrips();

      if (!mounted) return;

      if (trips.isEmpty) {
        // Create a default "AI Recommendations" trip
        final defaultTrip = {
          'name': 'AI Recommendations',
          'savedCards': [],
        };
        await TripStorage.saveTrip(defaultTrip);
      }

      // Convert recommendation to card format
      final cardData = {
        'name': recommendation.title,
        'image': recommendation.image,
        'description': recommendation.description,
        'stars': 4.5, // Default rating
        'reason': recommendation.reason,
      };

      // Show save dialog using existing component
      await showDialog(
        context: context,
        builder: (context) => SaveToTripDialog(
          trips: trips.isEmpty ? ['AI Recommendations'] : trips,
          onTripSelected: (trip) async {
            await TripStorage.saveCardToTrip(trip, cardData);
            await StorageService.saveRecommendation(recommendation);
            await _loadSavedRecommendations();
            if (mounted) {
              _showSuccessSnackBar('Saved to "$trip"!');
              HapticFeedback.lightImpact();
            }
          },
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Failed to save recommendation: $e');
    }
  }

  void _bookRecommendation(Recommendation recommendation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(recommendation: recommendation),
      ),
    );
  }

  void _showSavedRecommendations() async {
    final savedRecommendations = await StorageService.getSavedRecommendations();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Recommendations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: savedRecommendations.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No saved recommendations yet'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: savedRecommendations.length,
                      itemBuilder: (context, index) {
                        final recommendation = savedRecommendations[index];
                        return RecommendationCard(
                          recommendation: recommendation,
                          onSave: () async {
                            await StorageService.removeRecommendation(recommendation.title);
                            Navigator.pop(context);
                            _showSuccessSnackBar('Recommendation removed from saved');
                          },
                          onBook: () {
                            Navigator.pop(context);
                            _bookRecommendation(recommendation);
                          },
                          isSaved: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
