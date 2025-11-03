import 'package:easytrip/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../data/model/touristic_site.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onSave;
  final VoidCallback onBook;
  final VoidCallback? onTap;
  final bool isSaved;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onSave,
    required this.onBook,
    this.onTap,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                recommendation.image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12), // Reduced from 16
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  recommendation.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16, // Reduced from 20
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6), // Reduced from 8

                // Reason chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, // Reduced from 12
                    vertical: 4, // Reduced from 6
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16), // Reduced from 20
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 14, // Reduced from 16
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          recommendation.reason,
                          style: TextStyle(
                            fontSize: 10, // Reduced from 12
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8), // Reduced from 12

                // Description
                Text(
                  recommendation.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12, // Reduced from 14
                    height: 1.3, // Reduced from 1.4
                  ),
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12), // Reduced from 16

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: onSave,
                        isOutlined: true,
                        height: 36, // Reduced from 40
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSaved ? Icons.bookmark_remove : Icons.bookmark_add,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                isSaved ? 'Remove' : 'Save',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        onPressed: onBook,
                        height: 36, // Reduced from 40
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flight_takeoff, size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            const Flexible(
                              child: Text(
                                'Book Now', 
                                style: TextStyle(color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
