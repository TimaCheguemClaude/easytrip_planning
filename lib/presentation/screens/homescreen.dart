import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/presentation/screens/sidebar_menu.dart';
import 'package:easytrip/presentation/widgets/destination_search_bar.dart';
import 'package:easytrip/presentation/widgets/destination_search_bottom_sheet.dart';
import 'package:easytrip/presentation/widgets/destination_carousel.dart';
import 'package:easytrip/presentation/widgets/plan_trip_card.dart';
import 'package:easytrip/presentation/screens/plan_form_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color.fromARGB(255, 250, 250, 250)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color.fromARGB(255, 250, 250, 250)),
            onPressed: () {},
          ),
        ],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DestinationSearchBar(
                onSearchTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) => const DestinationSearchBottomSheet(),
                  );
                },
              ),
              const SizedBox(height: 8),
              const DestinationCarousel(),
              const SizedBox(height: 6),
              PlanTripCard(
                onPlanTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlanFormPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
