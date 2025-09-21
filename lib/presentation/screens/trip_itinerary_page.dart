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
  int? _expandedTileIndex;
  // Only one _saveItinerary method should exist
  Future<void> _saveItinerary() async {
    final key = 'itinerary_${widget.tripName!.replaceAll(' ', '_')}';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(_itinerary));
  }

  void _editItineraryTime(int index, Map<String, dynamic> item) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.parse(item['dateTime'])),
    );
    if (pickedTime == null) return;
    final dt = DateTime.parse(item['dateTime']);
    final newDateTime = DateTime(
      dt.year,
      dt.month,
      dt.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      _itinerary[index]['dateTime'] = newDateTime.toIso8601String();
    });
    await _saveItinerary();
  }

  void _toggleDone(int index) async {
    setState(() {
      _itinerary[index]['done'] = !(_itinerary[index]['done'] ?? false);
    });
    await _saveItinerary();
  }

  void _deleteItineraryItem(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        _itinerary.removeAt(index);
      });
      await _saveItinerary();
    }
  }

  DateTimeRange? _tripDateRange;
  bool _firstBuild = true;
  List<Map<String, dynamic>> _itinerary = [];

  @override
  void initState() {
    super.initState();
    if (widget.tripName != null) {
      _loadTripDateRange();
    }
  }

  Future<void> _loadTripDateRange() async {
    final trip = await TripStorage.getTrip(widget.tripName!);
    if (trip != null && trip['dateStart'] != null && trip['dateEnd'] != null) {
      setState(() {
        _tripDateRange = DateTimeRange(
          start: DateTime.parse(trip['dateStart']),
          end: DateTime.parse(trip['dateEnd']),
        );
      });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) {
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
        // Build all days in the trip's date range
        List<String> allDates = [];
        if (_tripDateRange != null) {
          DateTime d = _tripDateRange!.start;
          while (!d.isAfter(_tripDateRange!.end)) {
            allDates.add(d.toString().substring(0, 10));
            d = d.add(const Duration(days: 1));
          }
        } else {
          allDates = grouped.keys.toList();
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Itinerary Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_itinerary.isEmpty)
              const Center(child: Text('No itinerary items yet.')),
            ...allDates.asMap().entries.map((entry) {
              final index = entry.key;
              final dateStr = entry.value;
              final items = grouped[dateStr] ?? [];
              items.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
              return Theme(
                data: theme.copyWith(
                  cardColor: theme.cardTheme.color,
                  dividerColor: theme.dividerColor,
                ),
                child: ExpansionTile(
                  key: PageStorageKey(dateStr),
                  initiallyExpanded: _expandedTileIndex == index,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedTileIndex = expanded ? index : null;
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'No activities for this day.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ...List.generate(items.length, (i) {
                      final item = items[i];
                      final dt =
                          item['dateTime'] != null &&
                              DateTime.tryParse(item['dateTime']) != null
                          ? DateTime.parse(item['dateTime']).toLocal()
                          : null;
                      final timeStr = dt != null
                          ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                          : '';
                      final done = item['done'] ?? false;
                      // Find index in _itinerary for CRUD
                      final globalIndex = _itinerary.indexWhere(
                        (it) =>
                            it['dateTime'] == item['dateTime'] &&
                            it['name'] == item['name'],
                      );
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 12,
                                  top: 6,
                                ),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: done
                                      ? Colors.green
                                      : theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: done
                                        ? Colors.green
                                        : theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Checkbox(
                                  value: done,
                                  onChanged: (_) => _toggleDone(globalIndex),
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              if (i < items.length - 1)
                                Container(
                                  width: 4,
                                  height: 40,
                                  color: done
                                      ? Colors.green
                                      : theme.colorScheme.primary,
                                ),
                            ],
                          ),
                          Expanded(
                            child: Card(
                              color: done
                                  ? Colors.green[50]
                                  : theme.cardTheme.color,
                              margin: const EdgeInsets.only(bottom: 8, left: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: done
                                      ? Colors.green
                                      : theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                leading: item['image'] != null
                                    ? Image.asset(
                                        item['image'],
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                title: Text(
                                  item['name'] ?? '',
                                  style: TextStyle(
                                    decoration: done
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: done ? Colors.green : null,
                                  ),
                                ),
                                subtitle: Text(timeStr),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.access_time,
                                        color: theme.colorScheme.primary,
                                      ),
                                      tooltip: 'Edit time',
                                      onPressed: () =>
                                          _editItineraryTime(globalIndex, item),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Delete',
                                      onPressed: () =>
                                          _deleteItineraryItem(globalIndex),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
