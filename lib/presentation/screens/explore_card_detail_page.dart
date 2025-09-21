import 'package:flutter/material.dart';
import '../../utils/trip_storage.dart';

class ExploreCardDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> reviews;
  final List<Map<String, dynamic>> similarItems;

  const ExploreCardDetailPage({
    super.key,
    required this.item,
    required this.imageUrls,
    required this.reviews,
    required this.similarItems,
  });

  @override
  State<ExploreCardDetailPage> createState() => _ExploreCardDetailPageState();
}

class _ExploreCardDetailPageState extends State<ExploreCardDetailPage> {
  bool isSaved = false;
  bool isLiked = false;

  void _saveCard() async {
    final trips = await TripStorage.listAllTrips();
    if (trips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trips found. Create a trip first.')),
      );
      return;
    }
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Save to Trip'),
        children: trips
            .map(
              (trip) => SimpleDialogOption(
                child: Text(trip),
                onPressed: () async {
                  await TripStorage.saveCardToTrip(trip, widget.item);
                  setState(() => isSaved = true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Saved to "$trip"')));
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final reviews = widget.reviews;
    final similarItems = widget.similarItems;
    final imageUrls = widget.imageUrls;
    return Scaffold(
      appBar: AppBar(title: Text(item['name'] ?? 'Details')),
      body: ListView(
        children: [
          // Like and Save buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  tooltip: isLiked ? 'Unlike' : 'Like',
                  onPressed: () {
                    setState(() => isLiked = !isLiked);
                  },
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.grey,
                  ),
                  tooltip: isSaved ? 'Unsave' : 'Save to trip',
                  onPressed: isSaved ? null : _saveCard,
                ),
              ],
            ),
          ),
          // Image carousel
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) => Image.asset(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              item['description'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),
          // Reviews section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...reviews.map(
            (review) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(review['user'] ?? ''),
              subtitle: Text(review['comment'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  review['stars'] ?? 0,
                  (i) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Similar places section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Similar Places',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: similarItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final sim = similarItems[index];
                return SizedBox(
                  width: 140,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 12,
                          child: Image.asset(sim['image'], fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            sim['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
