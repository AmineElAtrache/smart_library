import 'package:flutter/material.dart';

class AppThemes {
  // Color Constants
  static const Color darkBg = Color(0xFF0F0F0F); // Almost black background
  static const Color darkCardBg = Color(0xFF1A1A1A); // Card/surface color
  static const Color darkSecondaryBg = Color(0xFF252525); // Secondary background
  static const Color accentColor = Color(0xFF64B5F6); // Light blue accent
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0); // Light grey text
  static const Color textTertiary = Color(0xFF808080); // Darker grey text
  static const Color borderColor = Color(0xFF333333); // Subtle border

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: const Color(0xFF1976D2),
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1976D2),
      secondary: const Color(0xFF03DAC6),
      surface: Colors.white,
      error: Colors.red,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black87),
      displayLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
    ),
  );

  // Dark Theme - Premium Look
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: darkBg,
    canvasColor: darkBg,
    cardColor: darkCardBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: accentColor,
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: accentColor,
      surface: darkCardBg,
      error: Colors.redAccent,
      onSurface: textPrimary,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textSecondary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      bodySmall: TextStyle(color: textTertiary, fontSize: 12),
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      titleSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 14),
      labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: const BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSecondaryBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      hintStyle: const TextStyle(color: textTertiary),
      labelStyle: const TextStyle(color: textSecondary),
      helperStyle: const TextStyle(color: textTertiary),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return textTertiary;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentColor.withOpacity(0.4);
        }
        return darkSecondaryBg;
      }),
    ),
    dividerColor: borderColor,
    dialogBackgroundColor: darkCardBg,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkSecondaryBg,
      disabledColor: textTertiary,
      selectedColor: accentColor,
      secondarySelectedColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: textPrimary),
      secondaryLabelStyle: const TextStyle(color: Colors.black),
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),
  );
}
