import 'package:flutter/material.dart';
import 'save_to_trip_dialog.dart';
import '../screens/explore_card_detail_page.dart';
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                // You can replace the below with real data as needed
                // For demo, use the item's image and a few sample images
                // and mock reviews/similar items
                // You may want to pass the city/category for better suggestions
                // and fetch more images from your assets
                // This is a minimal working demo
                // You can expand the imageUrls, reviews, and similarItems as needed
                // For now, use the item's image 3 times for the carousel
                // and similar items from the same category if available
                // (You can improve this logic as you wish)
                // Import ExploreCardDetailPage at the top of this file
                // import '../screens/explore_card_detail_page.dart';
                // (add this import if not present)
                //
                // For now, let's assume it's imported
                //
                // ignore: prefer_const_constructors
                ExploreCardDetailPage(
                  item: item,
                  imageUrls: [item['image'], item['image'], item['image']],
                  reviews: [
                    {'user': 'Alice', 'comment': 'Amazing place!', 'stars': 5},
                    {'user': 'Bob', 'comment': 'Had a great time.', 'stars': 4},
                  ],
                  similarItems: [item],
                ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image section with fixed aspect ratio
                AspectRatio(
                  aspectRatio: 16 / 12,
                  child: Stack(
                    children: [
                      // Main image
                      Image.asset(
                        item['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isSaved ? Icons.favorite : Icons.favorite_border,
                              color: isSaved ? Colors.redAccent : Colors.white,
                              size: 22,
                            ),
                            onPressed: isSaved
                                ? _unsaveFromAllTrips
                                : _showSaveDialog,
                            tooltip: isSaved
                                ? 'Unsave from all trips'
                                : 'Save to trip',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ...existing code...
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name
                      Text(
                        item['name'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            item['stars'].toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Description
                      Container(
                        height: 32,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Text(
                            item['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
