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
          backgroundColor: AppTheme.navyCard,
          onRefresh: () async => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Row(
                children: [
                  const MosqueLogo(size: 52),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('منبه الفجر',
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: AppTheme.muted),
                          const SizedBox(width: 4),
                          Text(_storage.cityName,
                              style: const TextStyle(
                                  color: AppTheme.muted, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dates
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.navyCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(gregorian,
                        style: const TextStyle(
                            color: AppTheme.cream, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(hijriStr,
                        style: const TextStyle(
                            color: AppTheme.goldSoft,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const CountdownCard(),
              const IqamaCountdownCard(),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: Text('أوقات اليوم',
                    style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              PrayerList(prayers: today, highlightKey: next.key),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QiblaScreen()),
                  ),
                  icon: const Icon(Icons.explore),
                  label: const Text('اتجاه القبلة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hijriMonthAr(int m) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[(m - 1) % 12];
  }
}
