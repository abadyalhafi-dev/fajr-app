import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'theme/app_theme.dart';
import 'main_navigation.dart';
import 'services/storage_service.dart';
import 'services/alarm_service.dart';
import 'services/prayer_service.dart';
import 'screens/alarm_ringing_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Each step is guarded so a failure can never block the app from starting.
  try {
    await initializeDateFormatting('ar', null);
  } catch (_) {}

  try {
    await StorageService().init();
  } catch (_) {}

  try {
    await AlarmService().init(_onAlarmTap);
  } catch (_) {}

  try {
    await AndroidAlarmManager.initialize();
  } catch (_) {}

  // Start the UI immediately. Alarm scheduling happens later, after
  // permissions are granted (see _FajrAppState.initState).
  runApp(const FajrApp());
}

@pragma('vm:entry-point')
Future<void> _dailyReschedule() async {
  try {
    await StorageService().init();
    await AlarmService().init((_) {});
    await AlarmService().rescheduleAll();
  } catch (_) {}
}

@pragma('vm:entry-point')
void _onAlarmTap(NotificationResponse response) {
  final payload = response.payload ?? '';
  final isMain = payload.startsWith(AlarmService.payloadMain);
  final key = payload.split(':').last;
  final name = PrayerService.arabicNames[key] ?? 'الصلاة';

  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => AlarmRingingScreen(isMain: isMain, prayerName: name),
    ),
  );
}

class FajrApp extends StatefulWidget {
  const FajrApp({super.key});

  @override
  State<FajrApp> createState() => _FajrAppState();
}

class _FajrAppState extends State<FajrApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ask for permissions first, THEN schedule everything.
      try {
        await AlarmService().requestPermissions();
      } catch (_) {}

      try {
        await AndroidAlarmManager.periodic(
          const Duration(hours: 12),
          1357,
          _dailyReschedule,
          wakeup: true,
          rescheduleOnReboot: true,
        );
      } catch (_) {}

      try {
        await AlarmService().rescheduleAll();
      } catch (_) {}

      try {
        final response = await AlarmService().launchPayload();
        if (response != null) _onAlarmTap(response);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منبه الفجر',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.dark,
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const MainNavigation(),
    );
  }
}
