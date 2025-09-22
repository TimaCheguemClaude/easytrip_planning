import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/touristic_site.dart';

class StorageService {
  static const String _savedRecommendationsKey = 'saved_recommendations';

  static Future<void> saveRecommendation(Recommendation recommendation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRecommendations = await getSavedRecommendations();

      // Check if already saved
      final exists = savedRecommendations.any((rec) => rec.title == recommendation.title);
      if (!exists) {
        savedRecommendations.add(recommendation);
        final jsonList = savedRecommendations.map((rec) => rec.toMap()).toList();
        await prefs.setString(_savedRecommendationsKey, json.encode(jsonList));
      }
    } catch (e) {
      throw Exception('Failed to save recommendation: $e');
    }
  }

  static Future<List<Recommendation>> getSavedRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_savedRecommendationsKey);

      if (jsonString == null) return [];

      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => Recommendation.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> removeRecommendation(String title) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRecommendations = await getSavedRecommendations();

      savedRecommendations.removeWhere((rec) => rec.title == title);
      final jsonList = savedRecommendations.map((rec) => rec.toMap()).toList();
      await prefs.setString(_savedRecommendationsKey, json.encode(jsonList));
    } catch (e) {
      throw Exception('Failed to remove recommendation: $e');
    }
  }

  static Future<void> clearAllRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savedRecommendationsKey);
    } catch (e) {
      throw Exception('Failed to clear recommendations: $e');
    }
  }
}
