import 'dart:io';

import 'package:easytrip/presentation/screens/chat_bot_screen.dart';
import 'package:easytrip/presentation/screens/plan_form_page.dart';
import 'package:easytrip/presentation/screens/user_bookings_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/trip_storage.dart';
import '../widgets/animated_fab.dart';
import 'trip_detail_page.dart';

class Tripscreen extends StatefulWidget {
  const Tripscreen({super.key});

  @override
  State<Tripscreen> createState() => _TripscreenState();
}

class _TripscreenState extends State<Tripscreen> with RouteAware, SingleTickerProviderStateMixin {
  late TabController _tabController;
  // To enable automatic refresh on navigation, add a RouteObserver to your MaterialApp
  // and subscribe/unsubscribe here using that observer. See Flutter docs for details.

  @override
  void didPopNext() {
    // Called when coming back to this screen
    setState(() {
      _futureTrips = _loadTrips();
    });
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Colors.grey, size: 32),
    );
  }

  late Future<List<Map<String, dynamic>>> _futureTrips;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureTrips = _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadTrips() async {
    final tripNames = await TripStorage.listAllTrips();
    final trips = <Map<String, dynamic>>[];
    for (final name in tripNames) {
      final trip = await TripStorage.getTrip(name);
      if (trip != null) trips.add(trip);
    }

    return trips;
  }

  void _onCreateTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanFormPage()),
    );
  }

  void _onBuildWithAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatBotScreen(initialMessage: ''),
      ),
    );
  }

  void _onModifyTrip(Map<String, dynamic> trip) {
    // Navigate to TripDetailPage for modification
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripDetailPage(trip: trip)),
    );
  }

  void _onDeleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text(
          'Are you sure you want to delete "${trip['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await TripStorage.deleteTrip(trip['name']);
              Navigator.pop(context);
              setState(() {
                _futureTrips = _loadTrips();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trip "${trip['name']}" deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Widget _buildPlaceholderImage() {
  //   return Container(
  //     width: 56,
  //     height: 56,
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: const Icon(Icons.image, color: Colors.grey, size: 32),
  //   );
  // }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    Widget leadingWidget;
    String? img;
    // Prefer trip['image'], else first valid in trip['images']
    if (trip['image'] != null && trip['image'].toString().isNotEmpty) {
      img = trip['image'].toString();
    } else if (trip['images'] is List && (trip['images'] as List).isNotEmpty) {
      final imagesList = (trip['images'] as List)
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .toList();
      if (imagesList.isNotEmpty) {
        img = imagesList.first;
      }
    }
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('/') ||
          img.contains(':\\') ||
          img.contains('storage') ||
          img.contains('data/user')) {
        final file = File(img);
        if (file.existsSync()) {
          leadingWidget = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
            ),
          );
        } else {
          // File path but file missing: show placeholder
          leadingWidget = _buildPlaceholderImage();
        }
      } else {
        // Try asset
        leadingWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            img,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          ),
        );
      }
    } else {
      // No image at all: show placeholder
      leadingWidget = _buildPlaceholderImage();
    }
    // Widget _buildPlaceholderImage() {
    //   return Container(
    //     width: 56,
    //     height: 56,
    //     decoration: BoxDecoration(
    //       color: Colors.grey[300],
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     child: const Icon(Icons.image, color: Colors.grey, size: 32),
    //   );
    // }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TripDetailPage(trip: trip)),
          );
        },
        leading: leadingWidget,
        title: Text(
          trip['name'] ?? 'Untitled Trip',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trip['dateStart'] != null)
              Text(
                'Start: ${trip['dateStart'].toString().split('T')[0]}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            if (trip['savedCards'] != null && trip['savedCards'] is List)
              Text(
                '${(trip['savedCards'] as List).length} saved places',
                style: TextStyle(color: Colors.blue[600], fontSize: 12),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'modify') _onModifyTrip(trip);
            if (value == 'delete') _onDeleteTrip(trip);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'modify', child: Text('Modify')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips & Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.luggage),
              text: 'My Trips',
            ),
            Tab(
              icon: Icon(Icons.book_online),
              text: 'Bookings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTripsTab(),
          const UserBookingsScreen(),
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        onCreateTrip: _onCreateTrip,
        onBuildWithAI: _onBuildWithAI,
      ),
    );
  }

  Widget _buildTripsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTrips,
        builder: (context, snapshot) {
          final trips = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No trips found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first trip or save recommendations to see them here',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final now = DateTime.now();
          final upcoming = <Map<String, dynamic>>[];
          final past = <Map<String, dynamic>>[];
          final current = <Map<String, dynamic>>[];
          final noDate = <Map<String, dynamic>>[];

          // Categorize trips based on dates
          for (final trip in trips) {
            final startDate = trip['dateStart'] != null
                ? DateTime.tryParse(trip['dateStart'].toString())
                : null;
            final endDate = trip['dateEnd'] != null
                ? DateTime.tryParse(trip['dateEnd'].toString())
                : null;

            if (startDate == null && endDate == null) {
              // No date information - show in "My Trips" section
              noDate.add(trip);
            } else if (startDate != null && endDate != null) {
              if (startDate.isAfter(now)) {
                upcoming.add(trip);
              } else if (endDate.isBefore(now)) {
                past.add(trip);
              } else {
                current.add(trip);
              }
            } else if (startDate != null) {
              if (startDate.isAfter(now)) {
                upcoming.add(trip);
              } else {
                current.add(trip);
              }
            } else {
              noDate.add(trip);
            }
          }

          return ListView(
            children: [
              // Current trips
              if (current.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Current Trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...current.map(_buildTripCard),
              ],

              // Upcoming trips
              if (upcoming.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Upcoming Trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...upcoming.map(_buildTripCard),
              ],

              // My trips (no date or saved recommendations)
              if (noDate.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My Trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...noDate.map(_buildTripCard),
              ],

              // Past trips
              if (past.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Past Trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...past.map(_buildTripCard),
              ],
            ],
          );
        },
      );
    
  }
}
