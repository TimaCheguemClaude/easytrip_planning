import 'onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Commande facile",
        descriptions: "Passez votre commande en quelques clics et laissez-nous nous occuper de la livraison de votre colis.",
        image: "assets/download.jpg"),

    OnboardingInfo(
        title: "Suivi en temps réel",
        descriptions: "Suivez votre colis en temps réel et soyez informé de chaque étape de son acheminement.",
        image: "assets/download1.jpg"),

   /* OnboardingInfo(
        title: "Paiement sécurisé",
        descriptions: "Payez en toute sécurité via mobile money ou carte bancaire pour une expérience sans souci.",
        image: "assets/onboarding3.gif"),*/

    OnboardingInfo(
        title: "Livraison rapide",
        descriptions: "Nous livrons vos colis rapidement et en toute sécurité, où que vous soyez.",
        image: "assets/download2.jpg"),
  ];
}
