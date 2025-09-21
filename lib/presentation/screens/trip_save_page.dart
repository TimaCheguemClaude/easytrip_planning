import 'package:flutter/material.dart';
import '../../utils/trip_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripSavePage extends StatefulWidget {
  final String tripName;
  const TripSavePage({Key? key, required this.tripName}) : super(key: key);

  @override
  State<TripSavePage> createState() => _TripSavePageState();
}

class _TripSavePageState extends State<TripSavePage> {
  Future<void> _addToItinerary(Map<String, dynamic> card) async {
    // Get trip date range
    final trip = await TripStorage.getTrip(widget.tripName);
    DateTime? startDate;
    DateTime? endDate;
    if (trip != null && trip['dateStart'] != null && trip['dateEnd'] != null) {
      startDate = DateTime.tryParse(trip['dateStart']);
      endDate = DateTime.tryParse(trip['dateEnd']);
    }
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: (startDate != null && now.isBefore(startDate))
          ? startDate
          : now,
      firstDate: startDate ?? DateTime(2020),
      lastDate: endDate ?? DateTime(2100),
      selectableDayPredicate: (date) {
        if (startDate != null && endDate != null) {
          return !date.isBefore(startDate) && !date.isAfter(endDate);
        }
        return true;
      },
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;
    final dateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    final prefs = await SharedPreferences.getInstance();
    final key = 'itinerary_${widget.tripName.replaceAll(' ', '_')}';
    final existing = prefs.getString(key);
    List<Map<String, dynamic>> itinerary = [];
    if (existing != null) {
      itinerary = List<Map<String, dynamic>>.from(jsonDecode(existing));
    }
    final newItem = Map<String, dynamic>.from(card);
    newItem['dateTime'] = dateTime.toIso8601String();
    itinerary.add(newItem);
    itinerary.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
    await prefs.setString(key, jsonEncode(itinerary));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added to itinerary!')));
  }

  late Future<List<Map<String, dynamic>>> _futureSaved;

  @override
  void initState() {
    super.initState();
    _futureSaved = TripStorage.getSavedCards(widget.tripName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureSaved,
      builder: (context, snapshot) {
        final saved = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (saved.isEmpty) {
          return const Center(child: Text('No saved places yet.'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: saved
              .map(
                (item) => Card(
                  child: ListTile(
                    leading: Image.asset(
                      item['image'] ?? '',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add to itinerary',
                      onPressed: () => _addToItinerary(item),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
