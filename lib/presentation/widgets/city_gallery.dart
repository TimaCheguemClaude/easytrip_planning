import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class CityGallery extends StatelessWidget {
  const CityGallery({super.key, this.onCityTap, this.onSeeAll});

  final void Function(String city)? onCityTap;
  final VoidCallback? onSeeAll;

  static final List<_CityItem> _cities = [
    _CityItem('Douala', 'assets/dataset/douala/activities/wouri.png'),
    _CityItem('Yaounde', 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg'),
    _CityItem('Kribi', 'assets/dataset/kribi/activities/chutelobekribi.jpg'),
    _CityItem('Buea', 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.exploreByCity, style: Theme.of(context).textTheme.titleLarge),
            TextButton(onPressed: onSeeAll, child: Text(l10n.seeAll)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = _cities[index];
              return _CityCard(
                name: item.name,
                image: item.image,
                onTap: () => onCityTap?.call(item.name),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: _cities.length,
          ),
        ),
      ],
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.name, required this.image, this.onTap});

  final String name;
  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
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
              Image.asset(image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, 
                      Theme.of(context).colorScheme.shadow.withOpacity(0.6)
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.near_me_outlined, 
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.exploreButton,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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

class _CityItem {
  final String name;
  final String image;
  _CityItem(this.name, this.image);
}


