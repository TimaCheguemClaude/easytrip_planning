import 'package:easytrip/presentation/Onboboarding/onboarding_items.dart';
import 'package:easytrip/presentation/Onboboarding/onboarding_info.dart';
import 'package:easytrip/presentation/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;
  
  List<OnboardingInfo> get items => controller.getItems(context);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 123, 213),
      bottomSheet: Container(
        color: Color.fromARGB(255, 58, 123, 213),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Skip Button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        pageController.jumpToPage(items.length - 1),
                    child: Text(l10n.skip),
                  ),

                  //Indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: items.length,
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeIn,
                    ),
                    effect: const WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: Colors.blue,
                    ),
                  ),

                  //Next Button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeIn,
                    ),
                    child: Text(l10n.next),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index) =>
              setState(() => isLastPage = items.length - 1 == index),
          itemCount: items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(items[index].image),
                const SizedBox(height: 15),
                Text(
                  items[index].title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  items[index].descriptions,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  //Now the problem is when press get started button
  // after re run the app we see again the onboarding screen
  // so lets do one time onboarding

  //Get started button

  Widget getStarted() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color.fromARGB(255, 58, 123, 213),
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
        onPressed: () async {
          final pres = await SharedPreferences.getInstance();
          pres.setBool("onboarding", true);

          //After we press get started button this onboarding value become true
          // same key
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => LoginScreen()),
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
        child: Text(l10n.getStarted, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
