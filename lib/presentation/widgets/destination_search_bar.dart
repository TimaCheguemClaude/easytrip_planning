import 'package:flutter/material.dart';

class DestinationSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  const DestinationSearchBar({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Select your next destination',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search, size: 32),
          onPressed: onSearchTap,
        ),
      ],
    );
  }
}
