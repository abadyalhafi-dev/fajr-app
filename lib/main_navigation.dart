import 'package:flutter/material.dart';

import 'l10n/strings.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/alarm_settings_screen.dart';
import 'screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Rebuild all tabs immediately when the language changes.
    appLang.addListener(_onLang);
  }

  void _onLang() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    appLang.removeListener(_onLang);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      CalendarScreen(),
      AlarmSettingsScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded), label: tr('nav_home')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_rounded),
              label: tr('nav_calendar')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.alarm_rounded), label: tr('nav_alarm')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings_rounded),
              label: tr('nav_settings')),
        ],
      ),
    );
  }
}
