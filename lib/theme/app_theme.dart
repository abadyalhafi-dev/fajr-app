import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark navy + gold theme for the Fajr app.
class AppTheme {
  // Core palette
  static const Color navy = Color(0xFF0B1B2B); // deep navy background
  static const Color navyCard = Color(0xFF132B40); // card surface
  static const Color navyLight = Color(0xFF1C3A56); // lighter surface / borders
  static const Color gold = Color(0xFFD4AF37); // primary gold accent
  static const Color goldSoft = Color(0xFFE8C97A); // softer gold for text
  static const Color cream = Color(0xFFF3EFE6); // primary readable text
  static const Color muted = Color(0xFF9FB3C8); // secondary text

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).apply(
      bodyColor: cream,
      displayColor: cream,
    );

    return base.copyWith(
      scaffoldBackgroundColor: navy,
      primaryColor: gold,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: goldSoft,
        surface: navyCard,
        onPrimary: navy,
        onSurface: cream,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: navy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.tajawal(
          color: goldSoft,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: goldSoft),
      ),
      cardTheme: CardThemeData(
        color: navyCard,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return gold;
          return muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return gold.withOpacity(0.4);
          }
          return navyLight;
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navyCard,
        selectedItemColor: gold,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: navy,
          textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        ),
      ),
      dividerColor: navyLight,
    );
  }
}
