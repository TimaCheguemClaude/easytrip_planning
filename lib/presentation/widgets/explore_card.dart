import 'package:flutter/material.dart';
import 'save_to_trip_dialog.dart';
import '../../utils/trip_storage.dart';
import '../screens/trip_detail_page.dart';

class ExploreCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const ExploreCard({super.key, required this.item});

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  bool isSaved = false;

  void _showSaveDialog() async {
    final trips = await TripStorage.listAllTrips();
    await showDialog(
      context: context,
      builder: (context) => SaveToTripDialog(
        trips: trips,
        onTripSelected: (trip) async {
          await TripStorage.saveCardToTrip(trip, widget.item);
          setState(() {
            isSaved = true;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Saved to "$trip"')));
          final tripData = await TripStorage.getTrip(trip);
          if (tripData != null && mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TripDetailPage(trip: tripData)),
            );
          }
        },
      ),
    );
  }

  void _unsaveFromAllTrips() async {
    final trips = await TripStorage.listAllTrips();
    for (final trip in trips) {
      await TripStorage.unsaveCardFromTrip(trip, widget.item);
    }
    setState(() {
      isSaved = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card unsaved from all trips')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Card(
      child: SizedBox(
        height: 190,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  item['image'],
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : Colors.grey,
                    ),
                    onPressed: isSaved ? _unsaveFromAllTrips : _showSaveDialog,
                    tooltip: isSaved ? 'Unsave from all trips' : 'Save to trip',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(item['stars'].toString()),
                      ],
                    ),
                    Text(
                      item['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
