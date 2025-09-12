import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TripCarousel extends StatefulWidget {
  final Map<String, dynamic> trip;
  const TripCarousel({super.key, required this.trip});

  @override
  State<TripCarousel> createState() => _TripCarouselState();
}

class _TripCarouselState extends State<TripCarousel> {
  List<String> _images = [];
  File? _pickedImage;

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
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = List<Widget>.from(
      _images.map((img) => Image.asset(img, fit: BoxFit.cover)),
    );
    if (_pickedImage != null) {
      images.add(Image.file(_pickedImage!, fit: BoxFit.cover));
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
                onPressed: () {}, // Share logic later
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
