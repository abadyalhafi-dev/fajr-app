import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';

import 'prayer_service.dart';
import 'storage_service.dart';

/// Alarm engine built on the `alarm` package (v5).
/// Plays a bundled sound through a native foreground service, loops until
/// stopped, wakes the screen, and fires even if the app is killed.
class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final PrayerService _prayer = PrayerService();
  final StorageService _storage = StorageService();

  // Bundled sounds (must exist in assets/sounds/).
  static const String _mainSound = 'assets/sounds/adhan_madinah.mp3';
  static const String _preSound = 'assets/sounds/default_alarm.wav';

  // Payload prefixes so the UI knows which screen text to show.
  static const String payloadMain = 'main:';
  static const String payloadPre = 'pre:';

  // Base IDs per prayer; a day offset (0..6) is added on top.
  static const Map<String, int> _baseIds = {
    'fajr_pre': 1000,
    'fajr': 2000,
    'dhuhr': 3000,
    'asr': 4000,
    'maghrib': 5000,
    'isha': 6000,
  };

  static const int _daysAhead = 7;

  Future<void> init() async {
    await Alarm.init();
  }

  Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  NotificationSettings _notif(String title) => NotificationSettings(
        title: title,
        body: 'اضغط لإيقاف المنبه',
        stopButton: 'إيقاف',
      );

  /// Cancel any alarms we previously set (by our known ID range).
  Future<void> _cancelKnown() async {
    for (final base in _baseIds.values) {
      for (int day = 0; day < _daysAhead; day++) {
        try {
          await Alarm.stop(base + day);
        } catch (_) {}
      }
    }
  }

  /// Schedule every enabled prayer for the next [_daysAhead] days.
  Future<void> rescheduleAll() async {
    await _cancelKnown();
    final now = DateTime.now();

    for (int day = 0; day < _daysAhead; day++) {
      final date = now.add(Duration(days: day));
      final prayers = _prayer.prayersForDate(date);

      for (final p in prayers) {
        if (!_storage.isPrayerAlarmEnabled(p.key)) continue;
        if (p.time.isBefore(now)) continue;

        await _setAlarm(
          id: _baseIds[p.key]! + day,
          when: p.time,
          title: 'حان وقت ${p.arabicName}',
          asset: _mainSound,
          payload: '$payloadMain${p.key}',
        );

        if (p.key == 'fajr' && _storage.preAlarmEnabled) {
          final preTime =
              p.time.subtract(Duration(minutes: _storage.preAlarmMinutes));
          if (preTime.isAfter(now)) {
            await _setAlarm(
              id: _baseIds['fajr_pre']! + day,
              when: preTime,
              title: 'اقترب وقت الفجر',
              asset: _preSound,
              payload: '${payloadPre}fajr',
            );
          }
        }
      }
    }
  }

  Future<void> _setAlarm({
    required int id,
    required DateTime when,
    required String title,
    required String asset,
    required String payload,
  }) async {
    final settings = AlarmSettings(
      id: id,
      dateTime: when,
      assetAudioPath: asset,
      loopAudio: false,
      vibrate: _storage.vibrationEnabled,
      warningNotificationOnKill: false,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 5),
        volumeEnforced: false,
      ),
      notificationSettings: _notif(title),
      payload: payload,
    );
    await Alarm.set(alarmSettings: settings);
  }

  Future<void> stop(int id) async {
    await Alarm.stop(id);
  }
}
