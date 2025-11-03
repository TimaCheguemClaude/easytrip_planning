import 'onboarding_info.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingItems {
  List<OnboardingInfo> getItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      OnboardingInfo(
          title: l10n.planYourTripsEasily,
          descriptions: l10n.organizeYourJourneys,
          image: "assets/onboarding.jpeg"),

      OnboardingInfo(
          title: l10n.discoverNewPlaces,
          descriptions: l10n.getRecommendations,
          image: "assets/onboarding1.jpeg"),

      OnboardingInfo(
          title: l10n.stayOnSchedule,
          descriptions: l10n.manageYourItinerary,
          image: "assets/onboarding2.jpeg"),
    ];
  }
}
