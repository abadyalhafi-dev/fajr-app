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

/// Global navigator key so alarm taps can push the ringing screen from anywhere.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Arabic date formatting symbols.
  await initializeDateFormatting('ar', null);

  // Storage first — everything depends on it.
  await StorageService().init();

  // Android alarm manager (for the daily reschedule task).
  await AndroidAlarmManager.initialize();

  // Notifications / alarms.
  await AlarmService().init(_onAlarmTap);

  // Schedule a daily job to refresh tomorrow's prayer times/alarms.
  await AndroidAlarmManager.periodic(
    const Duration(hours: 12),
    1357, // unique id
    _dailyReschedule,
    wakeup: true,
    rescheduleOnReboot: true,
  );

  // Schedule current alarms now.
  await AlarmService().rescheduleAll();

  runApp(const FajrApp());
}

/// Background task: re-compute and re-schedule alarms (runs in own isolate).
@pragma('vm:entry-point')
Future<void> _dailyReschedule() async {
  await StorageService().init();
  await AlarmService().init((_) {});
  await AlarmService().rescheduleAll();
}

/// Called when the user taps an alarm notification.
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
    _checkLaunchedByAlarm();
    // Ask for permissions shortly after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlarmService().requestPermissions();
    });
  }

  Future<void> _checkLaunchedByAlarm() async {
    final response = await AlarmService().launchPayload();
    if (response != null) {
      _onAlarmTap(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منبه الفجر',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.dark,
      // Force Arabic + RTL across the whole app.
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
