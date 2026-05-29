import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Light Theme - iPod/iTunes Classic Aesthetic
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFD8DCE3),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5E6772),
      secondary: Color(0xFF9BA3AD),
      surface: Color(0xFFE8EAED),
      background: Color(0xFFD8DCE3),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF1A1D23),
      onSurface: Color(0xFF1A1D23),
      onBackground: Color(0xFF1A1D23),
    ),

    cardTheme: const CardThemeData(
      elevation: 8,
      shadowColor: Colors.black26,
      color: Color(0xFFF5F5F7),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF5F5F7),
      foregroundColor: const Color(0xFF1A1D23),
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFE8EAED),
      selectedItemColor: Color(0xFF5E6772),
      unselectedItemColor: Color(0xFF8A9199),
      elevation: 8,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1D23),
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1D23),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1A1D23),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF5E6772),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8A9199),
      ),
    ),
  );

  // Dark Theme
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1D23),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9BA3AD),
      secondary: Color(0xFF5E6772),
      surface: Color(0xFF2A2D33),
      background: Color(0xFF1A1D23),
      onPrimary: Color(0xFF1A1D23),
      onSecondary: Color(0xFFE8EAED),
      onSurface: Color(0xFFE8EAED),
      onBackground: Color(0xFFE8EAED),
    ),

    cardTheme: const CardThemeData(
      elevation: 8,
      shadowColor: Colors.black54,
      color: Color(0xFF353841),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF353841),
      foregroundColor: const Color(0xFFE8EAED),
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2D33),
      selectedItemColor: Color(0xFF9BA3AD),
      unselectedItemColor: Color(0xFF5E6772),
      elevation: 8,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE8EAED),
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE8EAED),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFE8EAED),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9BA3AD),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF6E7681),
      ),
    ),
  );
}
