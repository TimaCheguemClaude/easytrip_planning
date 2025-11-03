import 'package:easytrip/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/l10n/app_localizations.dart';

import 'ai_recommendations_screen.dart';
import 'homescreen.dart';
import 'profilescreen.dart';
import 'walletscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AIRecommendationsScreen(),
    const Tripscreen(), // This will be the Explore screen
    const Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
              size: 28,
            ),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.auto_awesome : Icons.auto_awesome_outlined,
              size: 28,
            ),
            label: l10n.aiRecommendations,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.explore : Icons.explore_outlined,
              size: 28,
            ),
            label: l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
              size: 28,
            ),
            label: l10n.profile,
          ),
        ],
        ),
      ),
    );
  }
}
