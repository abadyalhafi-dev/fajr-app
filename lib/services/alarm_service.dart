import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:permission_handler/permission_handler.dart';

import 'prayer_service.dart';
import 'storage_service.dart';

/// Handles scheduling and firing the prayer alarms.
///
/// Strategy:
///  - Uses flutter_local_notifications scheduled with exactAllowWhileIdle,
///    which registers with the OS AlarmManager so it fires even if the app
///    is killed.
///  - Notifications use a full-screen intent (category=alarm) so the screen
///    wakes up like a real alarm clock.
///  - Tapping / opening the notification launches the AlarmRingingScreen,
///    which loops the user-selected audio until force-dismissed.
class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final PrayerService _prayer = PrayerService();
  final StorageService _storage = StorageService();

  // Payload prefixes so the UI knows which sound to play.
  static const String payloadMain = 'main:'; // main adhan
  static const String payloadPre = 'pre:'; // softer pre-alarm

  // Fixed notification IDs per prayer so we can cancel/replace cleanly.
  static const Map<String, int> _ids = {
    'fajr_pre': 100,
    'fajr': 101,
    'dhuhr': 102,
    'asr': 103,
    'maghrib': 104,
    'isha': 105,
  };

  Future<void> init(
      void Function(NotificationResponse) onTap) async {
    tzdata.initializeTimeZones();
    // Doha timezone; harmless if device differs — scheduling uses local time.
    tz.setLocalLocation(tz.getLocation('Asia/Qatar'));

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Alarm channel — high importance, full screen.
    const channel = AndroidNotificationChannel(
      'fajr_alarm_channel',
      'تنبيهات الصلاة',
      description: 'تنبيهات أوقات الصلاة',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request the permissions Android needs for exact, full-screen alarms.
  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
    // Battery optimization — ask the user to exempt the app.
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  AndroidNotificationDetails get _alarmDetails => const AndroidNotificationDetails(
        'fajr_alarm_channel',
        'تنبيهات الصلاة',
        channelDescription: 'تنبيهات أوقات الصلاة',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
        ongoing: true,
        autoCancel: false,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
      );

  /// Reschedule every enabled alarm for today/tomorrow.
  /// Call this on app start, after settings changes, and once daily.
  Future<void> rescheduleAll() async {
    await _plugin.cancelAll();

    final now = DateTime.now();

    // Schedule for the next 2 days so a killed app still has upcoming alarms.
    for (int dayOffset = 0; dayOffset < 2; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));
      final prayers = _prayer.prayersForDate(date);

      for (final p in prayers) {
        if (!_storage.isPrayerAlarmEnabled(p.key)) continue;
        if (p.time.isBefore(now)) continue;

        // Main alarm at prayer time.
        await _scheduleAt(
          id: _ids[p.key]! + dayOffset * 1000,
          when: p.time,
          title: 'حان وقت ${p.arabicName}',
          body: 'اضغط لإيقاف الأذان',
          payload: '$payloadMain${p.key}',
        );

        // Fajr pre-alarm (15 min before by default).
        if (p.key == 'fajr' && _storage.preAlarmEnabled) {
          final preTime =
              p.time.subtract(Duration(minutes: _storage.preAlarmMinutes));
          if (preTime.isAfter(now)) {
            await _scheduleAt(
              id: _ids['fajr_pre']! + dayOffset * 1000,
              when: preTime,
              title: 'اقترب وقت الفجر',
              body: 'تنبيه مبكر قبل ${_storage.preAlarmMinutes} دقيقة',
              payload: '${payloadPre}fajr',
            );
          }
        }
      }
    }
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required String payload,
  }) async {
    final tzTime = tz.TZDateTime.from(when, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      NotificationDetails(android: _alarmDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Used when the user dismisses the ringing alarm.
  Future<void> dismiss(int id) => _plugin.cancel(id);

  /// Returns a notification response if the app was launched by tapping one.
  Future<NotificationResponse?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse;
    }
    return null;
  }
}
