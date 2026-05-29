import 'package:flutter/material.dart';

/// Bảng màu Apple iPod Classic / iTunes cổ điển
/// Hai chế độ: Sáng (nhôm bạc) và Tối (than chì)
class AppColors {
  // ─── LIGHT MODE (Sáng) ────────────────────────
  static const lightBg = Color(0xFFE8E6E3);          // Nền nhôm bạc ấm
  static const lightSurface = Color(0xFFFFFFFF);      // Card trắng
  static const lightSurfaceAlt = Color(0xFFF5F5F5);   // Card phụ
  static const lightBorder = Color(0xFFD6D6D6);       // Viền nhẹ
  static const lightText = Color(0xFF1A1A1A);         // Text chính
  static const lightTextSecondary = Color(0xFF8E8E93);// Text phụ (iOS gray)
  static const lightNavBg = Color(0xFFF2F2F7);        // Bottom nav
  static const lightNavBorder = Color(0xFFD1D1D6);    // Nav border
  static const lightIcon = Color(0xFF3C3C43);         // Icon active
  static const lightIconInactive = Color(0xFF8E8E93); // Icon inactive
  static const lightPlayBtn = Color(0xFF1C1C1E);      // Nút play tối
  static const lightShadow = Color(0x29000000);       // Bóng mềm 16%

  // ─── DARK MODE (Tối) ─────────────────────────
  static const darkBg = Color(0xFF1C1C1E);            // Nền than chì
  static const darkSurface = Color(0xFF2C2C2E);       // Card tối
  static const darkSurfaceAlt = Color(0xFF3A3A3C);    // Card phụ
  static const darkBorder = Color(0xFF48484A);        // Viền tinh tế
  static const darkText = Color(0xFFFFFFFF);          // Text chính
  static const darkTextSecondary = Color(0xFF8E8E93); // Text phụ
  static const darkNavBg = Color(0xFF1C1C1E);         // Bottom nav
  static const darkNavBorder = Color(0xFF38383A);     // Nav border
  static const darkIcon = Color(0xFFFFFFFF);          // Icon active
  static const darkIconInactive = Color(0xFF636366);  // Icon inactive
  static const darkPlayBtn = Color(0xFFFFFFFF);       // Nút play sáng
  static const darkShadow = Color(0x40000000);        // Bóng 25%

  // ─── SHARED ───────────────────────────────────
  static const accent = Color(0xFF007AFF);            // iOS blue accent
}

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    fontFamily: 'Helvetica Neue',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w300),
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    ),
    colorScheme: const ColorScheme.light(
      surface: AppColors.lightSurface,
      primary: AppColors.lightPlayBtn,
      onSurface: AppColors.lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightText),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    fontFamily: 'Helvetica Neue',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w300),
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
    ),
    colorScheme: const ColorScheme.dark(
      surface: AppColors.darkSurface,
      primary: AppColors.darkPlayBtn,
      onSurface: AppColors.darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
    ),
  );
}
