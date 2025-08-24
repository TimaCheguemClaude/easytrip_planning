import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  // Primary colors for the app
  final Color primaryBlue = Color(0xFF2196F3);
  final Color primaryLightBlue = Color(0xFF64B5F6);
  final Color primaryDarkBlue = Color(0xFF1976D2);
  
  // Custom dark theme
  final darkTheme = ThemeData(
    primaryColor: Color(0xFF2196F3),
    primaryColorDark: Color(0xFF1976D2),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF121212),
      selectedItemColor: Color(0xFF2196F3),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
      titleLarge: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2196F3)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[800],
      thickness: 0.5,
    ),
  );

  // Custom light theme
  final lightTheme = ThemeData(
    primaryColor: Color(0xFF2196F3),
    primaryColorLight: Color(0xFF64B5F6),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2196F3),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Color(0xFF2196F3)),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2196F3)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 0.5,
    ),
  );

  // Dark mode toggle action
  void changeTheme() {
    _isDark = !_isDark;
    // Save the value to shared preferences
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  // Init method of provider
  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }
}