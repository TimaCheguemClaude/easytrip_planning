import 'dart:io';

import 'package:easytrip/presentation/screens/plan_form_page.dart';
import 'package:easytrip/presentation/screens/user_bookings_screen.dart';
import 'package:easytrip/presentation/screens/chat_bot_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/l10n/app_localizations.dart';

import '../../utils/trip_storage.dart';
import '../../utils/theme.dart';
import '../widgets/animated_fab.dart';
import 'trip_detail_page.dart';

class Tripscreen extends StatefulWidget {
  const Tripscreen({super.key});

  @override
  State<Tripscreen> createState() => _TripscreenState();
}

class _TripscreenState extends State<Tripscreen> with RouteAware, SingleTickerProviderStateMixin {
  late TabController _tabController;
  // To enable automatic refresh on navigation, add a RouteObserver to your MaterialApp
  // and subscribe/unsubscribe here using that observer. See Flutter docs for details.

  @override
  void didPopNext() {
    // Called when coming back to this screen
    setState(() {
      _futureTrips = _loadTrips();
    });
  }

  Widget _buildPlaceholderImage([ThemeData? theme]) {
    final currentTheme = theme ?? Theme.of(context);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: currentTheme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentTheme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.image,
        color: currentTheme.colorScheme.onSurface.withOpacity(0.4),
        size: 28,
      ),
    );
  }

  late Future<List<Map<String, dynamic>>> _futureTrips;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to update colors
    });
    _futureTrips = _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadTrips() async {
    final tripNames = await TripStorage.listAllTrips();
    final trips = <Map<String, dynamic>>[];
    for (final name in tripNames) {
      final trip = await TripStorage.getTrip(name);
      if (trip != null) trips.add(trip);
    }

    return trips;
  }

  void _onCreateTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanFormPage()),
    );
  }


  void _onModifyTrip(Map<String, dynamic> trip) {
    // Navigate to TripDetailPage for modification
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripDetailPage(trip: trip)),
    );
  }

  void _onDeleteTrip(Map<String, dynamic> trip) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTrip),
        content: Text(
          '${l10n.areYouSureDeleteTrip} "${trip['name']}"? ${l10n.thisActionCannotBeUndone}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await TripStorage.deleteTrip(trip['name']);
              Navigator.pop(context);
              setState(() {
                _futureTrips = _loadTrips();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.tripDeleted} "${trip['name']}"')),
              );
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  // Widget _buildPlaceholderImage() {
  //   return Container(
  //     width: 56,
  //     height: 56,
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: const Icon(Icons.image, color: Colors.grey, size: 32),
  //   );
  // }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    final l10n = AppLocalizations.of(context)!;
    Widget leadingWidget;
    String? img;
    // Prefer trip['image'], else first valid in trip['images']
    if (trip['image'] != null && trip['image'].toString().isNotEmpty) {
      img = trip['image'].toString();
    } else if (trip['images'] is List && (trip['images'] as List).isNotEmpty) {
      final imagesList = (trip['images'] as List)
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .toList();
      if (imagesList.isNotEmpty) {
        img = imagesList.first;
      }
    }
    if (img != null && img.isNotEmpty) {
      if (img.startsWith('/') ||
          img.contains(':\\') ||
          img.contains('storage') ||
          img.contains('data/user')) {
        final file = File(img);
        if (file.existsSync()) {
          leadingWidget = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
            ),
          );
        } else {
          // File path but file missing: show placeholder
          leadingWidget = _buildPlaceholderImage();
        }
      } else {
        // Try asset
        leadingWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            img,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          ),
        );
      }
    } else {
      // No image at all: show placeholder
      leadingWidget = _buildPlaceholderImage();
    }
    // Widget _buildPlaceholderImage() {
    //   return Container(
    //     width: 56,
    //     height: 56,
    //     decoration: BoxDecoration(
    //       color: Colors.grey[300],
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     child: const Icon(Icons.image, color: Colors.grey, size: 32),
    //   );
    // }
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TripDetailPage(trip: trip)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: leadingWidget,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['name'] ?? l10n.untitledTrip,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (trip['dateStart'] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${l10n.start}: ${trip['dateStart'].toString().split('T')[0]}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      if (trip['savedCards'] != null && trip['savedCards'] is List)
                        Row(
                          children: [
                            Icon(
                              Icons.bookmark,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(trip['savedCards'] as List).length} ${l10n.savedPlaces}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'modify') _onModifyTrip(trip);
                    if (value == 'delete') _onDeleteTrip(trip);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'modify',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: theme.colorScheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.modify, style: TextStyle(color: theme.colorScheme.onSurface)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(l10n.delete, style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    Provider.of<UiProvider>(context); // ensure rebuild on theme change
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight_takeoff,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.myTripsAndBookings,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.primaryColor.withOpacity(0.1),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.luggage,
                        size: 20,
                        color: _tabController.index == 0 
                            ? theme.primaryColor 
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.myTrips,
                        style: TextStyle(
                          color: _tabController.index == 0 
                              ? theme.primaryColor 
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: _tabController.index == 0 
                              ? FontWeight.bold 
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_online,
                        size: 20,
                        color: _tabController.index == 1 
                            ? theme.primaryColor 
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.bookings,
                        style: TextStyle(
                          color: _tabController.index == 1 
                              ? theme.primaryColor 
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: _tabController.index == 1 
                              ? FontWeight.bold 
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTripsTab(),
            const UserBookingsScreen(),
          ],
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        onCreateTrip: _onCreateTrip,
        onChatBot: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatBotScreen(initialMessage: ''),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripsTab() {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureTrips,
        builder: (context, snapshot) {
          final trips = snapshot.data ?? [];
          final theme = Theme.of(context);
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingYourTrips,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (trips.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.flight_takeoff,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noTripsYet,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.startPlanningAdventure,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _onCreateTrip,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createYourFirstTrip),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final now = DateTime.now();
          final upcoming = <Map<String, dynamic>>[];
          final past = <Map<String, dynamic>>[];
          final current = <Map<String, dynamic>>[];
          final noDate = <Map<String, dynamic>>[];

          // Categorize trips based on dates
          for (final trip in trips) {
            final startDate = trip['dateStart'] != null
                ? DateTime.tryParse(trip['dateStart'].toString())
                : null;
            final endDate = trip['dateEnd'] != null
                ? DateTime.tryParse(trip['dateEnd'].toString())
                : null;

            if (startDate == null && endDate == null) {
              // No date information - show in "My Trips" section
              noDate.add(trip);
            } else if (startDate != null && endDate != null) {
              if (startDate.isAfter(now)) {
                upcoming.add(trip);
              } else if (endDate.isBefore(now)) {
                past.add(trip);
              } else {
                current.add(trip);
              }
            } else if (startDate != null) {
              if (startDate.isAfter(now)) {
                upcoming.add(trip);
              } else {
                current.add(trip);
              }
            } else {
              noDate.add(trip);
            }
          }

          return ListView(
            children: [
              // Current trips
              if (current.isNotEmpty) ...[
                _buildSectionHeader(l10n.currentTrips, Icons.play_circle, theme),
                ...current.map(_buildTripCard),
              ],

              // Upcoming trips
              if (upcoming.isNotEmpty) ...[
                _buildSectionHeader(l10n.upcomingTrips, Icons.schedule, theme),
                ...upcoming.map(_buildTripCard),
              ],

              // My trips (no date or saved recommendations)
              if (noDate.isNotEmpty) ...[
                _buildSectionHeader(l10n.myTrips, Icons.luggage, theme),
                ...noDate.map(_buildTripCard),
              ],

              // Past trips
              if (past.isNotEmpty) ...[
                _buildSectionHeader(l10n.pastTrips, Icons.history, theme),
                ...past.map(_buildTripCard),
              ],
            ],
          );
        },
      );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
