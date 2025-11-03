import 'package:easytrip/presentation/screens/explore_city_page.dart';
import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class AllCitiesPage extends StatelessWidget {
  const AllCitiesPage({super.key});

  static const List<Map<String, String>> _cities = [
    {'name': 'Douala', 'image': 'assets/dataset/douala/activities/wouri.png'},
    {'name': 'Yaounde', 'image': 'assets/dataset/yaounde/hotels/Hilton Yaounde.jpg'},
    {'name': 'Kribi', 'image': 'assets/dataset/kribi/activities/chutelobekribi.jpg'},
    {'name': 'Buea', 'image': 'assets/dataset/yaounde/hotels/Hotel La Falaise.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.allCities)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          return _CityTile(
            name: city['name']!,
            image: city['image']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExploreCityPage(cityName: city['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({required this.name, required this.image, this.onTap});

  final String name;
  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




