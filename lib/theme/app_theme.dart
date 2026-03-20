import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF22C55E),
      primary: const Color(0xFF22C55E),
      surface: const Color(0xFFF8FAFC),
      onSurface: const Color(0xFF0F172A),
      secondary: const Color(0xFF4ADE80),
      error: const Color(0xFFEF4444),
      surfaceContainerHighest: const Color(0xFF0F2133),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: const Color(0xFF22C55E).withValues(alpha: 0.1)),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    ),
  );

  static ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF22C55E),
      primaryContainer: Color(0xFF0F2133),
      surface: Color(0xFF08121A),
      onSurface: Colors.white,
      secondary: Color(0xFF4ADE80),
      error: Color(0xFFEF4444),
      surfaceContainerHighest: Color(0xFF0F2133),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: const Color(0xFF22C55E).withValues(alpha: 0.1)),
      ),
      color: const Color(0xFF0F2133),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1),
      ),
    ),
  );
}
