import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import '../screens/explore_city_page.dart';

class DestinationSearchBottomSheet extends StatelessWidget {
  const DestinationSearchBottomSheet({super.key});

  static final List<_DestinationItem> _destinations = [
    _DestinationItem('Douala', 'assets/dataset/douala/activities/wouri.png'),
    _DestinationItem('Yaoundé', 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg'),
    _DestinationItem('Kribi', 'assets/dataset/kribi/activities/chutelobekribi.jpg'),
    _DestinationItem('Buea', 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search for your destination',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter destination...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _destinations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final destination = _destinations[index];
                  return _DestinationCard(
                    name: destination.name,
                    image: destination.image,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExploreCityPage(cityName: destination.name),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.name,
    required this.image,
    this.onTap,
  });

  final String name;
  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.shadow.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.near_me_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.exploreButton,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationItem {
  final String name;
  final String image;
  _DestinationItem(this.name, this.image);
}
