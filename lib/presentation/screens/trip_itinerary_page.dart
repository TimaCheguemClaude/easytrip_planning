import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../utils/trip_storage.dart';

class TripItineraryPage extends StatefulWidget {
  final String? tripName;
  const TripItineraryPage({Key? key, this.tripName}) : super(key: key);

  @override
  State<TripItineraryPage> createState() => _TripItineraryPageState();
}

class _TripItineraryPageState extends State<TripItineraryPage> {
  bool _firstBuild = true;
  late Future<List<Map<String, dynamic>>> _futureSaved;
  List<Map<String, dynamic>> _itinerary = [];

  @override
  void initState() {
    super.initState();
    if (widget.tripName != null) {
      _futureSaved = TripStorage.getSavedCards(widget.tripName!);
    } else {
      _futureSaved = Future.value([]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstBuild) {
      _firstBuild = false;
      if (widget.tripName != null) {
        _loadItinerary();
      }
    } else {
      // Always reload when dependencies change (e.g., after pop)
      if (widget.tripName != null) {
        _loadItinerary();
      }
    }
  }

  Future<void> _loadItinerary() async {
    final key = 'itinerary_${widget.tripName!.replaceAll(' ', '_')}';
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      setState(() {
        _itinerary = List<Map<String, dynamic>>.from(jsonDecode(data));
        _itinerary.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
      });
    }
  }

  void _addToItinerary(Map<String, dynamic> place) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
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
    final key = 'itinerary_${widget.tripName!.replaceAll(' ', '_')}';
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    List<Map<String, dynamic>> itinerary = [];
    if (data != null) {
      itinerary = List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    final newItem = Map<String, dynamic>.from(place);
    newItem['dateTime'] = dateTime.toIso8601String();
    itinerary.add(newItem);
    itinerary.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
    await prefs.setString(key, jsonEncode(itinerary));
    setState(() {
      _itinerary = itinerary;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to itinerary!')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureSaved,
      builder: (context, snapshot) {
        final saved = snapshot.data ?? [];
        // Group itinerary items by date (yyyy-MM-dd)
        final Map<String, List<Map<String, dynamic>>> grouped = {};
        for (final item in _itinerary) {
          final dateStr =
              item['dateTime'] != null &&
                  DateTime.tryParse(item['dateTime']) != null
              ? DateTime.parse(
                  item['dateTime'],
                ).toLocal().toString().substring(0, 10)
              : 'Unknown Date';
          grouped.putIfAbsent(dateStr, () => []).add(item);
        }
        final sortedDates = grouped.keys.toList()
          ..sort((a, b) => a.compareTo(b));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (saved.isNotEmpty)
              ExpansionTile(
                title: const Text('Add to Itinerary from Saved'),
                children: saved
                    .map(
                      (place) => ListTile(
                        leading: place['image'] != null
                            ? Image.asset(
                                place['image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : null,
                        title: Text(place['name'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addToItinerary(place),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 16),
            const Text(
              'Itinerary Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_itinerary.isEmpty)
              const Center(child: Text('No itinerary items yet.')),
            ...sortedDates.map((dateStr) {
              final items = grouped[dateStr]!;
              items.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...items.map((item) {
                        final dt =
                            item['dateTime'] != null &&
                                DateTime.tryParse(item['dateTime']) != null
                            ? DateTime.parse(item['dateTime']).toLocal()
                            : null;
                        final timeStr = dt != null
                            ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                            : '';
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 12, top: 6),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.blue[50],
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: item['image'] != null
                                      ? Image.asset(
                                          item['image'],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  title: Text(item['name'] ?? ''),
                                  subtitle: Text(timeStr),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
