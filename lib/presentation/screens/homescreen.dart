import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/presentation/screens/sidebar_menu.dart';
import 'package:easytrip/presentation/widgets/destination_search_bottom_sheet.dart';
import 'package:easytrip/presentation/screens/plan_form_page.dart';
import 'package:easytrip/presentation/widgets/city_gallery.dart';
import 'package:easytrip/presentation/widgets/popular_section.dart';
import 'package:easytrip/presentation/screens/notifications_page.dart';
import 'package:easytrip/presentation/screens/all_cities_page.dart';
import 'package:easytrip/presentation/screens/popular_all_page.dart';
import 'package:easytrip/presentation/screens/explore_city_page.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<Set<String>> _likedItems = ValueNotifier<Set<String>>({});
  final ValueNotifier<Map<String, int>> _commentCounts =
      ValueNotifier<Map<String, int>>({});

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UiProvider>(context); // ensure rebuild on theme change

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 240,
            centerTitle: false,
            leadingWidth: 56,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 72, bottom: 12),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'EasyTrip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _HeroBackground(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                          Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 64,
                    child: _SearchField(
                      controller: _searchController,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) => const DestinationSearchBottomSheet(),
                        );
                      },
                      onFilterTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) => const DestinationSearchBottomSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CityGallery(
                onCityTap: (city) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreCityPage(cityName: city),
                    ),
                  );
                },
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllCitiesPage()),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular now', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PopularAllPage(),
                        ),
                      );
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),
          PopularSection(
            likedItems: _likedItems,
            commentCounts: _commentCounts,
            onComment: (id) {
              final current = Map<String, int>.from(_commentCounts.value);
              current[id] = (current[id] ?? 0) + 1;
              _commentCounts.value = current;
            },
            onSave: (cardData) async {
              // Reuse SaveToTripDialog via InteractivePlaceCard
            },
            horizontal: true,
            maxItems: 7,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.planYourTrip,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.discoverCameroonBeauty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlanFormPage()),
                        );
                      },
                      icon: const Icon(Icons.edit_location_alt_outlined),
                      label: Text(AppLocalizations.of(context)!.planYourTrip),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// helper removed as city chips now route to ExploreCityPage

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onTap,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).textTheme.bodyMedium?.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Where to?', style: Theme.of(context).textTheme.bodyMedium),
              ),
              IconButton(
                tooltip: 'Filters',
                onPressed: onFilterTap,
                icon: Icon(Icons.tune, color: Theme.of(context).textTheme.titleSmall?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Cameroon image as background for search bar section
    return Image.asset(
      'assets/cameroon.jpg',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset('assets/plan it.jpg', fit: BoxFit.cover),
    );
  }
}
