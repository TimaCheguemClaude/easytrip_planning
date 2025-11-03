import 'package:flutter/material.dart';
import '../../utils/trip_storage.dart';
import 'trip_detail_page.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({super.key});

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  late Future<List<String>> _futureTrips;

  @override
  void initState() {
    super.initState();
    _futureTrips = TripStorage.listAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.yourTrips)),
      body: FutureBuilder<List<String>>(
        future: _futureTrips,
        builder: (context, snapshot) {
          final trips = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (trips.isEmpty) {
            return Center(child: Text(l10n.noTripsFound));
          }
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, i) {
              final tripName = trips[i];
              return ListTile(
                title: Text(tripName),
                onTap: () async {
                  final trip = await TripStorage.getTrip(tripName);
                  if (trip != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripDetailPage(trip: trip),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
