import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This is a standalone example app demonstrating the AI recommendations feature
// To use this, replace your main.dart content with this file

void main() {
  runApp(const AIRecommendationsExampleApp());
}

class AIRecommendationsExampleApp extends StatelessWidget {
  const AIRecommendationsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Travel Recommendations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AIRecommendationsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Models
class TouristicSite {
  final String title;
  final String city;
  final List<String> activities;
  final double price;
  final String image;
  final String description;

  TouristicSite({
    required this.title,
    required this.city,
    required this.activities,
    required this.price,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'city': city,
      'activities': activities,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}

class Recommendation {
  final String title;
  final String description;
  final String image;
  final String reason;

  Recommendation({
    required this.title,
    required this.description,
    required this.image,
    required this.reason,
  });

  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      reason: map['reason'] ?? '',
    );
  }
}

class UserPreferences {
  final double budget;
  final String city;
  final int numberOfPeople;
  final String preferredActivity;

  UserPreferences({
    required this.budget,
    required this.city,
    required this.numberOfPeople,
    required this.preferredActivity,
  });
}

// Dataset
class TouristicSitesDataset {
  static final List<TouristicSite> sites = [
    TouristicSite(
      title: 'Douala Maritime Museum',
      city: 'Douala',
      activities: ['Museum Tours', 'Cultural Learning', 'Photography', 'History'],
      price: 15000,
      image: 'assets/boatdla.jpg',
      description: 'Discover the rich maritime history of Douala, Cameroon\'s economic capital.',
    ),
    TouristicSite(
      title: 'Wouri River Cruise',
      city: 'Douala',
      activities: ['Boat Tours', 'Sightseeing', 'Photography', 'Relaxation'],
      price: 25000,
      image: 'assets/boatdla.jpg',
      description: 'Enjoy a scenic cruise along the Wouri River with stunning views.',
    ),
    TouristicSite(
      title: 'Chutes de la Lobé',
      city: 'Kribi',
      activities: ['Waterfall Viewing', 'Swimming', 'Photography', 'Nature Walks'],
      price: 10000,
      image: 'assets/chutelobekribi.jpg',
      description: 'Spectacular waterfalls that flow directly into the Atlantic Ocean.',
    ),
    TouristicSite(
      title: 'National Museum of Cameroon',
      city: 'Yaounde',
      activities: ['Museum Tours', 'Cultural Learning', 'Art Viewing', 'History'],
      price: 12000,
      image: 'assets/motoryde.jpg',
      description: 'Explore Cameroon\'s rich cultural heritage through artifacts and art.',
    ),
    TouristicSite(
      title: 'Kribi Beach Resort',
      city: 'Kribi',
      activities: ['Beach Relaxation', 'Swimming', 'Water Sports', 'Sunbathing'],
      price: 45000,
      image: 'assets/hotelkribi.jpg',
      description: 'Pristine beachfront resort with white sandy beaches.',
    ),
  ];

  static List<String> getAllCities() {
    return sites.map((site) => site.city).toSet().toList()..sort();
  }

  static List<String> getAllActivities() {
    final activities = <String>{};
    for (final site in sites) {
      activities.addAll(site.activities);
    }
    return activities.toList()..sort();
  }
}

// Mock Gemini Service (since we can't use real API in example)
class MockGeminiService {
  Future<List<Recommendation>> getRecommendations(UserPreferences preferences) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    final sites = TouristicSitesDataset.sites;
    final filteredSites = sites.where((site) {
      final matchesCity = site.city.toLowerCase() == preferences.city.toLowerCase();
      final matchesActivity = site.activities.any((activity) =>
        activity.toLowerCase().contains(preferences.preferredActivity.toLowerCase()));
      final withinBudget = site.price <= preferences.budget;

      return (matchesCity || matchesActivity) && withinBudget;
    }).toList();

    if (filteredSites.isEmpty) {
      filteredSites.addAll(sites.where((site) => site.price <= preferences.budget).take(3));
    }

    return filteredSites.take(3).map((site) => Recommendation(
      title: site.title,
      description: site.description,
      image: site.image,
      reason: _generateReason(site, preferences),
    )).toList();
  }

  String _generateReason(TouristicSite site, UserPreferences preferences) {
    final reasons = <String>[];

    if (site.city.toLowerCase() == preferences.city.toLowerCase()) {
      reasons.add('Located in your preferred city');
    }

    if (site.activities.any((activity) =>
        activity.toLowerCase().contains(preferences.preferredActivity.toLowerCase()))) {
      reasons.add('Matches your preferred activity');
    }

    if (site.price <= preferences.budget) {
      reasons.add('Fits within your budget');
    }

    if (preferences.numberOfPeople > 1) {
      reasons.add('Great for groups');
    }

    return reasons.isEmpty ? 'Popular destination' : reasons.join(', ');
  }
}

// Main Screen
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
  final MockGeminiService _geminiService = MockGeminiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Travel Recommendations'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _savedRecommendations.isNotEmpty,
              label: Text('${_savedRecommendations.length}'),
              child: const Icon(Icons.bookmark),
            ),
            onPressed: _showSavedRecommendations,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTripInputDialog,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
            CircularProgressIndicator(),
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
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _errorMessage = null),
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
            Icon(Icons.explore, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            const Text('Welcome to AI Travel Recommendations!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Tap the button below to get personalized recommendations',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            const Text('Available destinations:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TouristicSitesDataset.getAllCities()
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
      builder: (context) => TripInputDialog(onSubmit: _getRecommendations),
    );
  }

  Future<void> _getRecommendations(UserPreferences preferences) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recommendations = [];
    });

    try {
      final recommendations = await _geminiService.getRecommendations(preferences);
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

  void _saveRecommendation(Recommendation recommendation) {
    final exists = _savedRecommendations.any((rec) => rec.title == recommendation.title);
    if (!exists) {
      setState(() {
        _savedRecommendations.add(recommendation);
      });
      _showSuccessSnackBar('Recommendation saved!');
      HapticFeedback.lightImpact();
    } else {
      _showErrorSnackBar('Already saved!');
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

  void _showSavedRecommendations() {
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
                  const Text('Saved Recommendations',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _savedRecommendations.isEmpty
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
                      itemCount: _savedRecommendations.length,
                      itemBuilder: (context, index) {
                        final recommendation = _savedRecommendations[index];
                        return RecommendationCard(
                          recommendation: recommendation,
                          onSave: () {
                            setState(() {
                              _savedRecommendations.removeAt(index);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackBar('Recommendation removed');
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
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

// Widgets
class TripInputDialog extends StatefulWidget {
  final Function(UserPreferences) onSubmit;

  const TripInputDialog({super.key, required this.onSubmit});

  @override
  State<TripInputDialog> createState() => _TripInputDialogState();
}

class _TripInputDialogState extends State<TripInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();

  String? _selectedCity;
  int _numberOfPeople = 1;
  String? _selectedActivity;

  final List<String> _cities = TouristicSitesDataset.getAllCities();
  final List<String> _activities = TouristicSitesDataset.getAllActivities();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Get AI Recommendations',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Budget (CFA) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your budget';
                          final budget = double.tryParse(value);
                          if (budget == null || budget <= 0) return 'Please enter a valid budget';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Preferred City *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                        onChanged: (value) => setState(() => _selectedCity = value),
                        validator: (value) => value == null ? 'Please select a city' : null,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Number of People'),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _numberOfPeople > 1 ? () => setState(() => _numberOfPeople--) : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('$_numberOfPeople', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  onPressed: () => setState(() => _numberOfPeople++),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedActivity,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Activity *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_activity),
                        ),
                        items: _activities.map((activity) => DropdownMenuItem(value: activity, child: Text(activity))).toList(),
                        onChanged: (value) => setState(() => _selectedActivity = value),
                        validator: (value) => value == null ? 'Please select an activity' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Get Recommendations'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final preferences = UserPreferences(
        budget: double.parse(_budgetController.text),
        city: _selectedCity!,
        numberOfPeople: _numberOfPeople,
        preferredActivity: _selectedActivity!,
      );
      Navigator.of(context).pop();
      widget.onSubmit(preferences);
    }
  }
}

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onSave;
  final VoidCallback onBook;
  final bool isSaved;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onSave,
    required this.onBook,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.grey),
                  Text('Image placeholder', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recommendation.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(recommendation.reason, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
                ),
                const SizedBox(height: 12),
                Text(recommendation.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onSave,
                        icon: Icon(isSaved ? Icons.bookmark_remove : Icons.bookmark_add),
                        label: Text(isSaved ? 'Remove' : 'Save'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onBook,
                        icon: const Icon(Icons.flight_takeoff),
                        label: const Text('Book Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final Recommendation recommendation;

  const BookingScreen({super.key, required this.recommendation});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime? _selectedDate;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Trip'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.recommendation.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.recommendation.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(_selectedDate == null ? 'Select Travel Date *' : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Confirm Booking'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _processBooking() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('Booking Confirmed!'),
        content: Text('Your booking for "${widget.recommendation.title}" has been confirmed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
