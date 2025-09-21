import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/trip_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripCarousel extends StatefulWidget {
  final Map<String, dynamic> trip;
  const TripCarousel({super.key, required this.trip});

  @override
  State<TripCarousel> createState() => _TripCarouselState();
}

class _TripCarouselState extends State<TripCarousel> {
  Future<void> _shareTrip() async {
    // Load itinerary from shared preferences
    final tripName = widget.trip['name'] ?? '';
    final key = 'itinerary_${tripName.replaceAll(' ', '_')}';
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) {
      await Share.share('No itinerary found for this trip.');
      return;
    }
    final itinerary = List<Map<String, dynamic>>.from(jsonDecode(data));
    if (itinerary.isEmpty) {
      await Share.share('No itinerary items for this trip.');
      return;
    }
    // Group by date
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final item in itinerary) {
      final dateStr =
          item['dateTime'] != null &&
              DateTime.tryParse(item['dateTime']) != null
          ? DateTime.parse(
              item['dateTime'],
            ).toLocal().toString().substring(0, 10)
          : 'Unknown Date';
      grouped.putIfAbsent(dateStr, () => []).add(item);
    }
    // Format as text
    final buffer = StringBuffer();
    buffer.writeln(
      'Itinerary for ${widget.trip['name'] ?? ''} (${widget.trip['city'] ?? ''})',
    );
    for (final date in grouped.keys) {
      buffer.writeln('\n$date:');
      final items = grouped[date]!;
      items.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
      for (final item in items) {
        final dt =
            item['dateTime'] != null &&
                DateTime.tryParse(item['dateTime']) != null
            ? DateTime.parse(item['dateTime']).toLocal()
            : null;
        final timeStr = dt != null
            ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
            : '';
        buffer.writeln('  - $timeStr  ${item['name'] ?? ''}');
      }
    }
    await Share.share(buffer.toString());
  }

  bool _isPickingImage = false;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    final rawImages = widget.trip['images'] ?? [widget.trip['image']];
    _images =
        (rawImages as List?)
            ?.where((img) => img != null && img is String && img.isNotEmpty)
            .cast<String>()
            .toList() ??
        [];
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        // Copy the image to the app's documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'trip_${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
        final savedImage = await File(
          picked.path,
        ).copy('${appDir.path}/$fileName');
        if (widget.trip['name'] != null) {
          final trip = await TripStorage.getTrip(widget.trip['name']);
          if (trip != null) {
            trip['image'] = savedImage.path;
            await TripStorage.saveTrip(trip);
          }
        }
        setState(() {
          // Add the new image path to the local images list if not already present
          if (!_images.contains(savedImage.path)) {
            _images.add(savedImage.path);
          }
        });
      }
    } finally {
      _isPickingImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = <Widget>[];
    // Add images from the trip's images list
    for (final img in _images) {
      if (img.startsWith('/') ||
          img.contains(':\\') ||
          img.contains('storage') ||
          img.contains('data/user')) {
        final file = File(img);
        if (file.existsSync()) {
          images.add(
            Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          );
        }
      } else {
        images.add(Image.asset(img, fit: BoxFit.cover));
      }
    }
    // Always check widget.trip['image'] for the persisted image
    final tripImagePath = widget.trip['image'];
    if (tripImagePath != null &&
        tripImagePath is String &&
        tripImagePath.isNotEmpty) {
      final file = File(tripImagePath);
      if (file.existsSync()) {
        images.add(
          Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        );
      }
    }
    return Stack(
      children: [
        SizedBox(
          height: 220,
          child: PageView(
            children: images.isNotEmpty
                ? images
                : [Container(color: Colors.grey)],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo, color: Colors.white),
                onPressed: _pickImage,
                tooltip: 'Add Photo',
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareTrip,
                tooltip: 'Share Trip',
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.trip['city'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.trip['name'] ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (widget.trip['date'] != null)
                Text(
                  '${widget.trip['date'].toLocal()}'.split(' ')[0],
                  style: const TextStyle(color: Colors.white70),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
