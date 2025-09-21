import 'package:easytrip/presentation/screens/chat_bot_screen.dart';
import 'package:easytrip/presentation/screens/plan_form_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/animated_fab.dart';
import 'trip_detail_page.dart';
import '../../utils/trip_storage.dart';

class Tripscreen extends StatefulWidget {
  const Tripscreen({Key? key}) : super(key: key);

  @override
  State<Tripscreen> createState() => _TripscreenState();
}

class _TripscreenState extends State<Tripscreen> with RouteAware {
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
    _futureTrips = _loadTrips();
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
          trip['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: trip['dateStart'] != null
            ? Text(trip['dateStart'].toString().split('T')[0])
            : null,
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
      appBar: AppBar(title: const Text('My Trips')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTrips,
        builder: (context, snapshot) {
          final trips = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (trips.isEmpty) {
            return const Center(child: Text('No trips found.'));
          }
          final now = DateTime.now();
          final upcoming = trips.where((t) {
            final date = t['dateStart'] != null
                ? DateTime.tryParse(t['dateStart'])
                : null;
            return date != null && date.isAfter(now);
          }).toList();
          final past = trips.where((t) {
            final date = t['dateEnd'] != null
                ? DateTime.tryParse(t['dateEnd'])
                : null;
            return date != null && date.isBefore(now);
          }).toList();
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Upcoming Trips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...upcoming.map(_buildTripCard),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Past Trips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...past.map(_buildTripCard),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        onCreateTrip: _onCreateTrip,
        onBuildWithAI: _onBuildWithAI,
      ),
    );
  }
}
