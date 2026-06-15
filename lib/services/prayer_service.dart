import 'package:adhan/adhan.dart';
import 'storage_service.dart';

/// One prayer with its Arabic name, key, and time.
class PrayerSlot {
  final String key; // fajr, dhuhr, asr, maghrib, isha
  final String arabicName;
  final DateTime time;

  PrayerSlot({
    required this.key,
    required this.arabicName,
    required this.time,
  });
}

/// Calculates prayer times fully offline using the Umm al-Qura method.
class PrayerService {
  final StorageService _storage = StorageService();

  static const Map<String, String> arabicNames = {
    'fajr': 'الفجر',
    'sunrise': 'الشروق',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };

  /// Returns the 5 daily prayers (plus we keep sunrise internally) for a date.
  List<PrayerSlot> prayersForDate(DateTime date) {
    final coords = Coordinates(_storage.latitude, _storage.longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi; // standard for Asr in the Gulf

    final dateComponents = DateComponents(date.year, date.month, date.day);
    final pt = PrayerTimes(coords, dateComponents, params);

    PrayerSlot build(String key, DateTime t) {
      final adj = _storage.prayerAdjustment(key);
      return PrayerSlot(
        key: key,
        arabicName: arabicNames[key]!,
        time: t.add(Duration(minutes: adj)),
      );
    }

    return [
      build('fajr', pt.fajr),
      build('dhuhr', pt.dhuhr),
      build('asr', pt.asr),
      build('maghrib', pt.maghrib),
      build('isha', pt.isha),
    ];
  }

  List<PrayerSlot> todaysPrayers() => prayersForDate(DateTime.now());

  /// Returns the next upcoming prayer from now (looks into tomorrow if needed).
  PrayerSlot nextPrayer() {
    final now = DateTime.now();
    final today = todaysPrayers();
    for (final p in today) {
      if (p.time.isAfter(now)) return p;
    }
    // All of today's prayers passed -> return tomorrow's Fajr
    final tomorrow = prayersForDate(now.add(const Duration(days: 1)));
    return tomorrow.first;
  }
}
