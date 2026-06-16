import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

import '../services/prayer_service.dart';
import '../services/storage_service.dart';
import '../widgets/countdown_card.dart';
import '../widgets/iqama_countdown_card.dart';
import '../widgets/prayer_list.dart';
import '../widgets/mosque_logo.dart';
import 'qibla_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayer = PrayerService();
  final StorageService _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final today = _prayer.todaysPrayers();
    final next = _prayer.nextPrayer();
    final now = DateTime.now();

    final gregorian =
        DateFormat('EEEE، d MMMM yyyy', 'ar').format(now);
    final hijri = HijriCalendar.now();
    final hijriStr =
        '${hijri.hDay} ${_hijriMonthAr(hijri.hMonth)} ${hijri.hYear} هـ';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.gold,
          backgroundColor: A
