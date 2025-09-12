import 'package:easytrip/presentation/screens/chat_bot_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/animated_fab.dart';
import 'trip_detail_page.dart';
import '../../utils/trip_storage.dart';

class Tripscreen extends StatefulWidget {
  const Tripscreen({Key? key}) : super(key: key);

  @override
  State<Tripscreen> createState() => _TripscreenState();
}

class _TripscreenState extends State<Tripscreen> {
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
    // TODO: Navigate to trip creation form
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Create Trip')));
  }

  void _onBuildWithAI() {
    // TODO: Navigate to AI trip builder
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatBotScreen(initialMessage: 'Hello'),
      ),
    );
  }

  void _onModifyTrip(Map<String, dynamic> trip) {
    // TODO: Implement modify logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Modify ${trip['name']}')));
  }

  void _onDeleteTrip(Map<String, dynamic> trip) {
    // TODO: Implement delete logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Delete ${trip['name']}')));
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TripDetailPage(trip: trip)),
          );
        },
        leading: trip['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  trip['image'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            : null,
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
