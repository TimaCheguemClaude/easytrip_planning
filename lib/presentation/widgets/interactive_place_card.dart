import 'package:flutter/material.dart';

class InteractivePlaceCard extends StatelessWidget {
  const InteractivePlaceCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.likedItems,
    required this.commentCounts,
    required this.onComment,
    this.onSave,
    this.onTap,
  });

  final String id;
  final String title;
  final String subtitle;
  final String image;
  final num price;
  final ValueNotifier<Set<String>> likedItems;
  final ValueNotifier<Map<String, int>> commentCounts;
  final void Function(String id) onComment;
  final Future<void> Function(Map<String, dynamic> cardData)? onSave;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(image, fit: BoxFit.cover),
                Positioned(
                  right: 8,
                  top: 8,
                  child: _LikeButton(id: id, likedItems: likedItems),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _BookingButton(
                    onPressed: () {
                      _showBookingDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Hide price on home per requirement
              ],
            ),
          ),
          // Actions removed on home cards; shown in detail page instead
        ],
      ),
    ),
  );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.id, required this.likedItems});

  final String id;
  final ValueNotifier<Set<String>> likedItems;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: likedItems,
      builder: (context, likes, _) {
        final isLiked = likes.contains(id);
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () {
              final newSet = Set<String>.from(likes);
              if (isLiked) {
                newSet.remove(id);
              } else {
                newSet.add(id);
              }
              likedItems.value = newSet;
            },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.redAccent : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Price and action components removed from home cards per requirements

class _BookingButton extends StatelessWidget {
  const _BookingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_available, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                'Book',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showBookingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Book Your Trip'),
      content: const Text('Ready to book your trip? This will open the booking form where you can specify your travel dates and preferences.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking feature coming soon!')),
            );
          },
          child: const Text('Book Now'),
        ),
      ],
    ),
  );
}


