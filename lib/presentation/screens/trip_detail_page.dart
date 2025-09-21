import 'package:flutter/material.dart';
import '../widgets/trip_carousel.dart';
import '../widgets/trip_detail_navbar.dart';
import 'trip_save_page.dart';
import 'trip_itinerary_page.dart';
import 'trip_for_you_page.dart';
import 'trip_wallet_page.dart';

class TripDetailPage extends StatefulWidget {
  final Map<String, dynamic> trip;
  const TripDetailPage({super.key, required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  int _selectedIndex = 0;
  Key _itineraryKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TripCarousel(trip: widget.trip),
            TripDetailNavBar(
              selectedIndex: _selectedIndex,
              onTabSelected: (i) {
                setState(() {
                  _selectedIndex = i;
                  if (i == 1) {
                    // When switching to itinerary tab, force rebuild
                    _itineraryKey = UniqueKey();
                  }
                });
              },
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  TripSavePage(tripName: widget.trip['name'] ?? ''),
                  TripItineraryPage(
                    key: _itineraryKey,
                    tripName: widget.trip['name'] ?? '',
                  ),
                  TripForYouPage(),
                  TripWalletPage(trip: widget.trip),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Import the following pages in the next steps:
// TripSavePage, TripItineraryPage, TripForYouPage, TripWalletPage
