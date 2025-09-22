import 'dart:convert';

class TouristicSite {
  final String title;
  final String city;
  final List<String> activities;
  final double price;
  final String image;
  final String description;

  TouristicSite({
    required this.title,
    required this.city,
    required this.activities,
    required this.price,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'city': city,
      'activities': activities,
      'price': price,
      'image': image,
      'description': description,
    };
  }

  factory TouristicSite.fromMap(Map<String, dynamic> map) {
    return TouristicSite(
      title: map['title'] ?? '',
      city: map['city'] ?? '',
      activities: List<String>.from(map['activities'] ?? []),
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TouristicSite.fromJson(String source) =>
      TouristicSite.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TouristicSite(title: $title, city: $city, activities: $activities, price: $price, image: $image, description: $description)';
  }
}

class Recommendation {
  final String title;
  final String description;
  final String image;
  final String reason;

  Recommendation({
    required this.title,
    required this.description,
    required this.image,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'reason': reason,
    };
  }

  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      reason: map['reason'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Recommendation.fromJson(String source) =>
      Recommendation.fromMap(json.decode(source));
}

class UserPreferences {
  final double budget;
  final String city;
  final int numberOfPeople;
  final String preferredActivity;

  UserPreferences({
    required this.budget,
    required this.city,
    required this.numberOfPeople,
    required this.preferredActivity,
  });

  Map<String, dynamic> toMap() {
    return {
      'budget': budget,
      'city': city,
      'numberOfPeople': numberOfPeople,
      'preferredActivity': preferredActivity,
    };
  }
}
