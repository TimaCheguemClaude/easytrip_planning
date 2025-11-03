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
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF64B5F6),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    ),
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
      bodySmall: TextStyle(color: Colors.white54),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white70),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white70),
      labelMedium: TextStyle(color: Colors.white60),
      labelSmall: TextStyle(color: Colors.white54),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF2196F3)),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey[800], thickness: 0.5),
  );

  // Custom light theme
  final lightTheme = ThemeData(
    primaryColor: Color(0xFF2196F3),
    primaryColorLight: Color(0xFF64B5F6),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF64B5F6),
      background: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
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
      bodySmall: TextStyle(color: Colors.black45),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black87),
      titleSmall: TextStyle(color: Colors.black54),
      headlineLarge: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black87),
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black87),
      labelLarge: TextStyle(color: Colors.black54),
      labelMedium: TextStyle(color: Colors.black45),
      labelSmall: TextStyle(color: Colors.black38),
    ),
    iconTheme: IconThemeData(color: Color(0xFF2196F3)),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF2196F3)),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey[300], thickness: 0.5),
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
