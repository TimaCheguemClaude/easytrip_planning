import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripStorage {
  static Future<void> unsaveCardFromTrip(
    String tripName,
    Map<String, dynamic> card,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final trip = await getTrip(tripName);
    if (trip == null) return;
    final saved = List<Map<String, dynamic>>.from(trip['savedCards'] ?? []);
    saved.removeWhere((c) => c['name'] == card['name']);
    trip['savedCards'] = saved;
    await prefs.setString(_tripKey(tripName), jsonEncode(trip));
  }

  static Future<List<String>> listAllTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final tripKeys = keys.where((k) => k.startsWith('trip_')).toList();
    return tripKeys.map((k) => k.substring(5).replaceAll('_', ' ')).toList();
  }

  static String _tripKey(String tripName) =>
      'trip_${tripName.replaceAll(' ', '_')}';

  static Future<void> saveTrip(Map<String, dynamic> trip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tripKey(trip['name']), jsonEncode(trip));
  }

  static Future<Map<String, dynamic>?> getTrip(String tripName) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tripKey(tripName));
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<void> saveCardToTrip(
    String tripName,
    Map<String, dynamic> card,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final trip =
        await getTrip(tripName) ?? {'name': tripName, 'savedCards': []};
    final saved = List<Map<String, dynamic>>.from(trip['savedCards'] ?? []);
    if (!saved.any((c) => c['name'] == card['name'])) {
      saved.add(card);
      trip['savedCards'] = saved;
      await prefs.setString(_tripKey(tripName), jsonEncode(trip));
    }
  }

  static Future<List<Map<String, dynamic>>> getSavedCards(
    String tripName,
  ) async {
    final trip = await getTrip(tripName);
    if (trip == null) return [];
    return List<Map<String, dynamic>>.from(trip['savedCards'] ?? []);
  }
}
