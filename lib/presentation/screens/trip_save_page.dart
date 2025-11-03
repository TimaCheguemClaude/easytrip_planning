import 'package:flutter/material.dart';
import '../../utils/trip_storage.dart';
import '../../utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class TripSavePage extends StatefulWidget {
  final String tripName;
  const TripSavePage({Key? key, required this.tripName}) : super(key: key);

  @override
  State<TripSavePage> createState() => _TripSavePageState();
}

class _TripSavePageState extends State<TripSavePage> {
  Future<void> _deleteCard(Map<String, dynamic> card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: Text('Are you sure you want to delete "${card['name']}" from your saved places?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await TripStorage.unsaveCardFromTrip(widget.tripName, card);
      setState(() {
        _futureSaved = TripStorage.getSavedCards(widget.tripName);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${card['name']} removed from saved places'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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

  Widget _buildImageWidget(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Provider.of<UiProvider>(context); // ensure rebuild on theme change

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureSaved,
      builder: (context, snapshot) {
        final saved = snapshot.data ?? [];
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: theme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Loading saved places...',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }
        
        if (saved.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved places yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save places from recommendations\nto see them here',
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
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: saved.length,
          itemBuilder: (context, index) {
            final item = saved[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: _buildImageWidget(item['image']),
                title: Text(
                  item['name'] ?? 'Unknown Place',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: item['description'] != null
                    ? Text(
                        item['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: theme.primaryColor,
                      ),
                      tooltip: 'Add to itinerary',
                      onPressed: () => _addToItinerary(item),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      tooltip: 'Delete from saved',
                      onPressed: () => _deleteCard(item),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
