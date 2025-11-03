import 'package:flutter/material.dart';
import '../../utils/trip_storage.dart';
import '../../data/mock_explore_data.dart';
import '../../data/model/touristic_site.dart';
import 'booking_screen.dart';

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
  int likeCount = 0;
  final List<Map<String, dynamic>> comments = [];
  final TextEditingController commentController = TextEditingController();

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
  void initState() {
    super.initState();
    // Initialize with mock reviews if no reviews provided
    if (widget.reviews.isEmpty) {
      comments.addAll(_generateMockReviews());
    } else {
      comments.addAll(widget.reviews);
    }
    likeCount = comments.length * 2 + 5; // Initial like count based on reviews
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _addComment() {
    if (commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'user': 'You',
          'comment': commentController.text.trim(),
          'stars': 5,
          'timestamp': DateTime.now(),
          'avatar': '👤', // User avatar emoji
        });
        // Update like count when adding a comment
        likeCount += 1;
      });
      commentController.clear();
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final similarItems = widget.similarItems;
    final imageUrls = widget.imageUrls;
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Like, Save, and Booking buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '$likeCount',
                  color: isLiked ? Colors.red : Colors.grey,
                  onPressed: _toggleLike,
                ),
                _buildActionButton(
                  icon: Icons.comment,
                  label: '${comments.length}',
                  color: Colors.blue,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _buildCommentsSheet(),
                    );
                  },
                ),
                _buildActionButton(
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  label: isSaved ? 'Saved' : 'Save',
                  color: isSaved ? Colors.blue : Colors.grey,
                  onPressed: isSaved ? null : _saveCard,
                ),
                _buildActionButton(
                  icon: Icons.flight_takeoff,
                  label: 'Book',
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          recommendation: Recommendation(
                            title: widget.item['name'] ?? 'Unknown',
                            description: widget.item['description'] ?? '',
                            image: widget.item['image'] ?? 'assets/default.jpg',
                            reason: 'Discover this amazing place',
                          ),
                        ),
                      ),
                    );
                  },
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
          // Enhanced content section
          _buildEnhancedContent(item),
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
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: similarItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final sim = similarItems[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the similar item's detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreCardDetailPage(
                          item: sim,
                          imageUrls: [sim['image'] ?? 'assets/default.jpg'],
                          reviews: [],
                          similarItems: _getSimilarItemsForItem(sim),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.asset(
                                sim['image'] ?? 'assets/default.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sim['name'] ?? 'Unknown',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber[600],
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${sim['stars'] ?? 0}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    if (sim['likes'] != null)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 12,
                                            color: Colors.red[400],
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${sim['likes']}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews & Comments (${comments.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share your experience!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentCard(comment);
                    },
                  ),
          ),
          const Divider(),
          // Comment input section
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 2,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _addComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<Map<String, dynamic>> _getSimilarItemsForItem(Map<String, dynamic> currentItem) {
    // Try to determine the city and category from the current item
    // This is a simplified approach - in a real app, you'd pass this information
    final cities = ['Douala', 'Yaounde', 'Kribi'];
    final categories = ['places_to_stay', 'food_and_drinks', 'things_to_do', 'touristic_sites'];
    
    for (final city in cities) {
      for (final category in categories) {
        final categoryFeed = MockExploreData.getCategoryFeed(city, category);
        final foundItem = categoryFeed.firstWhere(
          (item) => item['name'] == currentItem['name'],
          orElse: () => <String, dynamic>{},
        );
        
        if (foundItem.isNotEmpty) {
          // Found the item, get similar items from the same category
          final similarItems = categoryFeed
              .where((item) => 
                  item['name'] != currentItem['name'] && 
                  item['isPlaceholder'] != true)
              .toList();
          
          // Sort by likes (descending), then by stars (descending)
          similarItems.sort((a, b) {
            final aLikes = a['likes'] ?? 0;
            final bLikes = b['likes'] ?? 0;
            if (aLikes != bLikes) return bLikes.compareTo(aLikes);
            return (b['stars'] ?? 0).compareTo(a['stars'] ?? 0);
          });
          
          // Return minimum 2, maximum 5 items
          final count = similarItems.length;
          if (count <= 2) {
            return similarItems; // Return all if 2 or fewer
          } else if (count <= 5) {
            return similarItems; // Return all if 5 or fewer
          } else {
            return similarItems.take(5).toList(); // Return top 5
          }
        }
      }
    }
    
    // Fallback: return empty list if item not found
    return [];
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  comment['avatar'] ?? comment['user'][0].toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['user'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (comment['timestamp'] != null)
                      Text(
                        _formatTimestamp(comment['timestamp']),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              // Star rating
              Row(
                children: List.generate(
                  comment['stars'] ?? 0,
                  (i) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment['comment'],
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateMockReviews() {
    final mockReviews = [
      {
        'user': 'Marie Dubois',
        'comment': 'Absolutely amazing place! The atmosphere is incredible and the service is top-notch. Highly recommended for anyone visiting the area.',
        'stars': 5,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'avatar': '👩',
      },
      {
        'user': 'Jean Pierre',
        'comment': 'Great experience overall. The food was delicious and the staff was very friendly. Will definitely come back!',
        'stars': 4,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'avatar': '👨',
      },
      {
        'user': 'Sarah Johnson',
        'comment': 'Beautiful location with stunning views. Perfect for a romantic dinner or special occasion. The ambiance is just perfect.',
        'stars': 4,
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'avatar': '👩‍🦰',
      },
      {
        'user': 'Ahmed Hassan',
        'comment': 'Good place but could be better. The service was a bit slow but the food quality made up for it. Worth a visit.',
        'stars': 5,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'avatar': '👨‍💼',
      },
      {
        'user': 'Fatima Al-Zahra',
        'comment': 'Excellent value for money! The portions are generous and the taste is authentic. Family-friendly environment.',
        'stars': 4,
        'timestamp': DateTime.now().subtract(const Duration(days: 5)),
        'avatar': '👩‍👧',
      },
    ];
    
    return mockReviews;
  }

  Widget _buildEnhancedContent(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Unknown Place',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getLocationText(item),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[600],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item['stars'] ?? 4.5}',
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Price section
          _buildPriceSection(item),
          const SizedBox(height: 16),
          
          // About this place
          _buildAboutSection(item),
          const SizedBox(height: 16),
          
          // Hashtags
          _buildHashtagsSection(item),
          const SizedBox(height: 16),
          
          // Features/Highlights
          _buildFeaturesSection(item),
          const SizedBox(height: 20),
          
          // Booking button
          _buildBookingButton(),
          const SizedBox(height: 16),
          
          // Reviews section
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildPriceSection(Map<String, dynamic> item) {
    final estimatedPrice = _getEstimatedPrice(item);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wallet,
            color: Colors.green[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Price',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  estimatedPrice,
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Per Person',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Place',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item['description'] ?? _getDefaultDescription(item),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHashtagsSection(Map<String, dynamic> item) {
    final hashtags = _getHashtags(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hashtags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              '#$tag',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(Map<String, dynamic> item) {
    final features = _getFeatures(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What to Expect',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildBookingButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                recommendation: Recommendation(
                  title: widget.item['name'] ?? 'Unknown',
                  description: widget.item['description'] ?? '',
                  image: widget.item['image'] ?? 'assets/default.jpg',
                  reason: 'Discover this amazing place',
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.flight_takeoff),
        label: const Text('Book Now'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews & Comments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => _buildCommentsSheet(),
                );
              },
              icon: const Icon(Icons.comment),
              label: Text('${comments.length}'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Show first 2 reviews as preview
        ...comments.take(2).map((comment) => _buildCommentCard(comment)),
        if (comments.length > 2)
          Center(
            child: TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => _buildCommentsSheet(),
                );
              },
              child: Text('View all ${comments.length} reviews'),
            ),
          ),
      ],
    );
  }

  String _getLocationText(Map<String, dynamic> item) {
    // Try to determine location from item data
    if (item['city'] != null) {
      return item['city'];
    }
    // Fallback based on item name or other data
    return 'Cameroon';
  }

  String _getEstimatedPrice(Map<String, dynamic> item) {
    // Generate estimated price based on item type and rating
    final stars = item['stars'] ?? 4.0;
    
    if (item['name']?.toString().toLowerCase().contains('hotel') == true ||
        item['name']?.toString().toLowerCase().contains('resort') == true) {
      return '${(15000 + (stars * 5000)).toInt()} - ${(25000 + (stars * 8000)).toInt()} FCFA';
    } else if (item['name']?.toString().toLowerCase().contains('restaurant') == true ||
               item['name']?.toString().toLowerCase().contains('cafe') == true) {
      return '${(3000 + (stars * 2000)).toInt()} - ${(8000 + (stars * 3000)).toInt()} FCFA';
    } else {
      return '${(5000 + (stars * 3000)).toInt()} - ${(15000 + (stars * 5000)).toInt()} FCFA';
    }
  }

  String _getDefaultDescription(Map<String, dynamic> item) {
    final name = item['name']?.toString().toLowerCase() ?? '';
    if (name.contains('hotel') || name.contains('resort')) {
      return 'A beautiful accommodation option offering comfortable rooms, excellent amenities, and outstanding service. Perfect for both business and leisure travelers looking for a memorable stay.';
    } else if (name.contains('restaurant') || name.contains('cafe')) {
      return 'A delightful dining experience featuring delicious cuisine, warm atmosphere, and exceptional service. Whether you\'re looking for a quick bite or a fine dining experience, this place has something special to offer.';
    } else {
      return 'An amazing destination that offers unique experiences and unforgettable memories. Whether you\'re exploring solo or with family and friends, this place promises to deliver an exceptional time filled with discovery and enjoyment.';
    }
  }

  List<String> _getHashtags(Map<String, dynamic> item) {
    final name = item['name']?.toString().toLowerCase() ?? '';
    final tags = <String>[];
    
    if (name.contains('hotel') || name.contains('resort')) {
      tags.addAll(['accommodation', 'luxury', 'comfort', 'service']);
    } else if (name.contains('restaurant') || name.contains('cafe')) {
      tags.addAll(['dining', 'cuisine', 'food', 'atmosphere']);
    } else {
      tags.addAll(['experience', 'adventure', 'discovery', 'fun']);
    }
    
    // Add location-based tags
    if (item['city'] != null) {
      tags.add(item['city'].toString().toLowerCase());
    }
    
    // Add rating-based tags
    final stars = item['stars'] ?? 4.0;
    if (stars >= 4.5) {
      tags.add('excellent');
    } else if (stars >= 4.0) {
      tags.add('great');
    }
    
    return tags.take(6).toList();
  }

  List<String> _getFeatures(Map<String, dynamic> item) {
    final name = item['name']?.toString().toLowerCase() ?? '';
    final features = <String>[];
    
    if (name.contains('hotel') || name.contains('resort')) {
      features.addAll([
        'Comfortable and clean rooms',
        'Professional and friendly staff',
        'Modern amenities and facilities',
        'Convenient location',
        'Excellent customer service',
      ]);
    } else if (name.contains('restaurant') || name.contains('cafe')) {
      features.addAll([
        'Delicious and fresh food',
        'Cozy and welcoming atmosphere',
        'Friendly and attentive service',
        'Great value for money',
        'Perfect for any occasion',
      ]);
    } else {
      features.addAll([
        'Unique and memorable experience',
        'Professional and knowledgeable guides',
        'Safe and well-organized activities',
        'Great for all ages',
        'Excellent value and quality',
      ]);
    }
    
    return features.take(5).toList();
  }
}
