import 'package:flutter/material.dart';
import '../screens/explore_city_page.dart';

class DestinationSearchBottomSheet extends StatelessWidget {
  const DestinationSearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Search for your destination',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter destination...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // Mock data for towns with navigation
            Card(
              child: ListTile(
                leading: Image.asset(
                  'assets/download.jpg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Douala'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreCityPage(cityName: 'Douala'),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset(
                  'assets/download1.jpg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Yaoundé'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreCityPage(cityName: 'Yaoundé'),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset(
                  'assets/download2.jpg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Kribi'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreCityPage(cityName: 'Kribi'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
