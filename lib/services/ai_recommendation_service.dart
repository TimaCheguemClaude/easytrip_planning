import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../data/model/touristic_site.dart';
import '../data/touristic_sites_dataset.dart';

class AIRecommendationService {
  // Use the same API key as the existing service
  static const String _apiKey = 'AIzaSyBC-9RMrysLNoEHBMkYgkO5hfwgswEiSpQ';

  Future<List<Recommendation>> getRecommendations(
    UserPreferences preferences,
  ) async {
    log('Starting AI recommendation request', name: 'AIRecommendationService');

    try {
      final prompt = _buildPrompt(preferences);
      log('Built recommendation prompt', name: 'AIRecommendationService');

      // Construct request payload using existing service pattern
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.3,
          'topK': 32,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        },
      };

      log(
        'Sending recommendation request to Gemini API',
        name: 'AIRecommendationService',
      );

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log(
        'Received response, status: ${response.statusCode}',
        name: 'AIRecommendationService',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final contentText =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        log('Successfully got AI response', name: 'AIRecommendationService');
        return _parseRecommendations(contentText);
      } else {
        log(
          'API request failed: ${response.statusCode}',
          name: 'AIRecommendationService',
        );
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in AI recommendations: $e', name: 'AIRecommendationService');
      // Fallback to mock recommendations if AI fails
      return _getMockRecommendations(preferences);
    }
  }

  String _buildPrompt(UserPreferences preferences) {
    // Use all available sites including existing data
    final dataset = TouristicSitesDataset.getAllSites();
    final datasetJson = dataset.map((site) => site.toMap()).toList();

    return '''
You are EasyTrip's AI recommendation engine. Based on the user's preferences and the provided dataset, recommend EXACTLY 3 touristic sites.

User Preferences:
- Budget: ${preferences.budget} CFA
- City: ${preferences.city}
- Number of people: ${preferences.numberOfPeople}
- Preferred activity: ${preferences.preferredActivity}

Available Dataset:
${json.encode(datasetJson)}

IMPORTANT RULES:
1. ONLY recommend sites from the provided dataset
2. Consider the user's budget (price per person should fit within budget)
3. Prioritize sites in the requested city, but can suggest nearby cities if needed
4. Match the preferred activity when possible
5. Return EXACTLY 3 recommendations
6. Response must be valid JSON format

Required JSON format:
{
  "recommendations": [
    {
      "title": "Site title from dataset",
      "description": "Brief description from dataset",
      "image": "Image path from dataset",
      "reason": "Why this site matches user preferences (budget, activity, location)"
    }
  ]
}

Respond with ONLY the JSON, no additional text.
''';
  }

  List<Recommendation> _parseRecommendations(String response) {
    try {
      log(
        'Parsing AI recommendations response',
        name: 'AIRecommendationService',
      );

      // Clean the response to extract JSON
      String cleanResponse = response.trim();
      if (cleanResponse.startsWith('```json')) {
        cleanResponse = cleanResponse.substring(7);
      }
      if (cleanResponse.endsWith('```')) {
        cleanResponse = cleanResponse.substring(0, cleanResponse.length - 3);
      }

      final jsonData = json.decode(cleanResponse);
      final recommendationsJson = jsonData['recommendations'] as List;

      final recommendations = recommendationsJson
          .map((rec) => Recommendation.fromMap(rec))
          .take(3)
          .toList();

      log(
        'Successfully parsed ${recommendations.length} recommendations',
        name: 'AIRecommendationService',
      );
      return recommendations;
    } catch (e) {
      log('Failed to parse AI response: $e', name: 'AIRecommendationService');
      throw Exception('Failed to parse recommendations: $e');
    }
  }

  List<Recommendation> _getMockRecommendations(UserPreferences preferences) {
    log(
      'Generating mock recommendations as fallback',
      name: 'AIRecommendationService',
    );

    // Use all available sites including existing data
    final sites = TouristicSitesDataset.getAllSites();
    final filteredSites = sites.where((site) {
      final matchesCity =
          site.city.toLowerCase() == preferences.city.toLowerCase();
      final matchesActivity = site.activities.any(
        (activity) => activity.toLowerCase().contains(
          preferences.preferredActivity.toLowerCase(),
        ),
      );
      final withinBudget = site.price <= preferences.budget;

      return (matchesCity || matchesActivity) && withinBudget;
    }).toList();

    if (filteredSites.isEmpty) {
      // If no matches, return budget-friendly options
      filteredSites.addAll(
        sites.where((site) => site.price <= preferences.budget).take(3),
      );
    }

    final recommendations = filteredSites
        .take(3)
        .map(
          (site) => Recommendation(
            title: site.title,
            description: site.description,
            image: site.image,
            reason: _generateReason(site, preferences),
          ),
        )
        .toList();

    log(
      'Generated ${recommendations.length} mock recommendations',
      name: 'AIRecommendationService',
    );
    return recommendations;
  }

  String _generateReason(TouristicSite site, UserPreferences preferences) {
    final reasons = <String>[];

    if (site.city.toLowerCase() == preferences.city.toLowerCase()) {
      reasons.add('Located in your preferred city');
    }

    if (site.activities.any(
      (activity) => activity.toLowerCase().contains(
        preferences.preferredActivity.toLowerCase(),
      ),
    )) {
      reasons.add('Matches your preferred activity');
    }

    if (site.price <= preferences.budget) {
      reasons.add('Fits within your budget');
    }

    if (preferences.numberOfPeople > 1) {
      reasons.add('Great for groups');
    }

    return reasons.isEmpty ? 'Popular destination' : reasons.join(', ');
  }
}
