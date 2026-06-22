import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light "dawn" theme for Ishraq — matches the app icon: soft peach→blue
/// gradient sky, white cards, iridescent purple as the lead accent, warm
/// amber (the sun) as the secondary accent.
///
/// NOTE: the semantic names below are kept (navy, gold, cream, ...) so screens
/// don't all need editing — only their *values* changed to the light palette.
class AppTheme {
  // Text
  static const Color cream = Color(0xFF322C44); // PRIMARY text (dark slate)
  static const Color muted = Color(0xFF837C99); // SECONDARY text (grey-purple)

  // Accents
  static const Color gold = Color(0xFF7B61C9); // PRIMARY accent → iridescent purple
  static const Color goldSoft = Color(0xFF6A57B0); // headings / accent text (deep purple)
  static const Color amber = Color(0xFFEEA23C); // SECONDARY accent → warm sun

  // Surfaces
  static const Color navy = Color(0xFFFFFFFF); // ON-ACCENT text/icon (white on purple)
  static const Color navyCard = Color(0xFFFFFCFB); // CARD surface (soft warm white)
  static const Color navyLight = Color(0xFFE9E3F5); // borders / tracks / unselected (lavender)

  // Dark colors reserved for the Fajr alarm screen (kept dark on purpose).
  static const Color alarmBg = Color(0xFF0B1B2B);
  static const Color alarmText = Color(0xFFF3EFE6);
  static const Color alarmMuted = Color(0xFF9FB3C8);
  static const Color alarmAccent = Color(0xFFE8C97A);

  // Dawn gradient sky (matches the icon): warm peach → cream → soft periwinkle.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8DAC8), // warm peach (top-left)
      Color(0xFFF3E7E1), // soft cream (middle)
      Color(0xFFCBD7EF), // gentle periwinkle blue (bottom-right)
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static ThemeData get dark {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).apply(
      bodyColor: cream,
      displayColor: cream,
    );

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: gold,
      colorScheme: const ColorScheme.light(
        primary: gold,
        secondary: amber,
        surface: navyCard,
        onPrimary: navy,
        onSurface: cream,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
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
        elevation: 3,
        shadowColor: gold.withOpacity(0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: gold.withOpacity(0.10),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return gold;
          return const Color(0xFFB9B2CC);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return gold.withOpacity(0.35);
          }
          return navyLight;
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFDF8F6),
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
