import 'package:shared_preferences/shared_preferences.dart';
import '../models/personal_event.dart';

/// Central key/value storage wrapper around SharedPreferences.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------- Location ----------------
  static const _kLat = 'loc_lat';
  static const _kLng = 'loc_lng';
  static const _kCity = 'loc_city';

  bool get hasLocation =>
      _prefs.containsKey(_kLat) && _prefs.containsKey(_kLng);

  double get latitude => _prefs.getDouble(_kLat) ?? 25.2854; // Doha default
  double get longitude => _prefs.getDouble(_kLng) ?? 51.5310; // Doha default
  String get cityName => _prefs.getString(_kCity) ?? 'الدوحة';

  Future<void> saveLocation(double lat, double lng, String city) async {
    await _prefs.setDouble(_kLat, lat);
    await _prefs.setDouble(_kLng, lng);
    await _prefs.setString(_kCity, city);
  }

  // ---------------- Sounds ----------------
  static const _kFajrSound = 'sound_fajr';
  static const _kPreSound = 'sound_pre';

  String? get fajrSoundPath => _prefs.getString(_kFajrSound);
  String? get preAlarmSoundPath => _prefs.getString(_kPreSound);

  Future<void> setFajrSound(String path) =>
      _prefs.setString(_kFajrSound, path);
  Future<void> setPreAlarmSound(String path) =>
      _prefs.setString(_kPreSound, path);

  // ---------------- Prayer alarm toggles ----------------
  // Fajr is always on. Others default OFF.
  static const _prefixEnabled = 'alarm_enabled_';

  bool isPrayerAlarmEnabled(String prayerKey) {
    // Fajr defaults ON but can be turned off; others default OFF.
    final defaultValue = prayerKey == 'fajr';
    return _prefs.getBool('$_prefixEnabled$prayerKey') ?? defaultValue;
  }

  Future<void> setPrayerAlarmEnabled(String prayerKey, bool value) =>
      _prefs.setBool('$_prefixEnabled$prayerKey', value);

  // Vibration on alarm — default ON
  static const _kVibration = 'vibration_enabled';
  bool get vibrationEnabled => _prefs.getBool(_kVibration) ?? true;
  Future<void> setVibrationEnabled(bool value) =>
      _prefs.setBool(_kVibration, value);

  // App language code (ar, en, fa, tr, ckb). null = not yet chosen.
  static const _kLang = 'app_language';
  String? get savedLanguage => _prefs.getString(_kLang);
  Future<void> setLanguage(String code) => _prefs.setString(_kLang, code);

  // Fajr pre-alarm (15 min before) toggle — default ON
  static const _kPreAlarmEnabled = 'pre_alarm_enabled';
  bool get preAlarmEnabled => _prefs.getBool(_kPreAlarmEnabled) ?? true;
  Future<void> setPreAlarmEnabled(bool value) =>
      _prefs.setBool(_kPreAlarmEnabled, value);

  // Minutes before Fajr for the pre-alarm (default 15)
  static const _kPreAlarmMinutes = 'pre_alarm_minutes';
  int get preAlarmMinutes => _prefs.getInt(_kPreAlarmMinutes) ?? 15;
  Future<void> setPreAlarmMinutes(int value) =>
      _prefs.setInt(_kPreAlarmMinutes, value);

  // ---------------- Manual time adjustments (minutes) ----------------
  static const _prefixAdjust = 'adjust_';
  int prayerAdjustment(String prayerKey) =>
      _prefs.getInt('$_prefixAdjust$prayerKey') ?? 0;
  Future<void> setPrayerAdjustment(String prayerKey, int minutes) =>
      _prefs.setInt('$_prefixAdjust$prayerKey', minutes);

  // ---------------- Iqama offsets (minutes after Adhan) ----------------
  static const _prefixIqama = 'iqama_';
  static const Map<String, int> _iqamaDefaults = {
    'fajr': 25,
    'dhuhr': 20,
    'asr': 25,
    'maghrib': 10,
    'isha': 20,
  };

  int iqamaOffset(String prayerKey) =>
      _prefs.getInt('$_prefixIqama$prayerKey') ??
      (_iqamaDefaults[prayerKey] ?? 15);

  Future<void> setIqamaOffset(String prayerKey, int minutes) =>
      _prefs.setInt('$_prefixIqama$prayerKey', minutes);

  // ---------------- Personal events ----------------
  static const _kEvents = 'personal_events';

  List<PersonalEvent> getEvents() {
    final raw = _prefs.getString(_kEvents);
    if (raw == null || raw.isEmpty) return [];
    try {
      return PersonalEvent.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveEvents(List<PersonalEvent> events) =>
      _prefs.setString(_kEvents, PersonalEvent.encodeList(events));
}
