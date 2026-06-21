import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/alarm_service.dart';
import 'city_picker_screen.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocationService _location = LocationService();
  final StorageService _storage = StorageService();
  final AlarmService _alarm = AlarmService();
  bool _loadingLocation = false;

  final List<Map<String, String>> _prayers = const [
    {'key': 'fajr', 'name': 'الفجر'},
    {'key': 'dhuhr', 'name': 'الظهر'},
    {'key': 'asr', 'name': 'العصر'},
    {'key': 'maghrib', 'name': 'المغرب'},
    {'key': 'isha', 'name': 'العشاء'},
  ];

  Future<void> _refreshLocation() async {
    setState(() => _loadingLocation = true);
    LocationResult result;
    try {
      result = await _location.fetchAndSave();
      try {
        await _alarm.rescheduleAll();
      } catch (_) {
        // Rescheduling can fail on its own; location is still saved.
      }
    } catch (e) {
      result = LocationResult(false, 'خطأ: $e');
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          backgroundColor:
              result.success ? Colors.green.shade700 : Colors.red.shade700,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Language picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: AppTheme.gold),
                        const SizedBox(width: 10),
                        Text(tr('language'),
                            style: const TextStyle(
                                color: AppTheme.goldSoft,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kSupportedLangs.map((code) {
                        final selected = appLang.value == code;
                        return ChoiceChip(
                          label: Text(kLangNames[code] ?? code),
                          selected: selected,
                          onSelected: (_) async {
                            appLang.value = code;
                            await _storage.setLanguage(code);
                            if (mounted) setState(() {});
                          },
                          selectedColor: AppTheme.gold,
                          backgroundColor: AppTheme.navyLight,
                          labelStyle: TextStyle(
                            color: selected ? AppTheme.navy : AppTheme.cream,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Location
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppTheme.gold),
                        const SizedBox(width: 10),
                        const Text('الموقع',
                            style: TextStyle(
                                color: AppTheme.goldSoft,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'المدينة: ${_storage.cityName}\n'
                      'خط العرض: ${_storage.latitude.toStringAsFixed(4)}\n'
                      'خط الطول: ${_storage.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(
                          color: AppTheme.muted, fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _loadingLocation ? null : _refreshLocation,
                      icon: _loadingLocation
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppTheme.navy),
                            )
                          : const Icon(Icons.my_location),
                      label: const Text('تحديد الموقع تلقائيًا (GPS)'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final changed = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CityPickerScreen()),
                        );
                        if (changed == true && mounted) setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.goldSoft,
                        side: const BorderSide(color: AppTheme.gold),
                      ),
                      icon: const Icon(Icons.location_city),
                      label: const Text('اختيار المدينة يدويًا'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Calculation method (fixed: Umm al-Qura)
            Card(
              child: ListTile(
                leading: const Icon(Icons.calculate, color: AppTheme.gold),
                title: const Text('طريقة الحساب',
                    style: TextStyle(color: AppTheme.cream)),
                subtitle: const Text('أم القرى',
                    style: TextStyle(color: AppTheme.muted)),
              ),
            ),

            const SizedBox(height: 8),

            // Manual adjustments
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('تعديل الأوقات (بالدقائق)',
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    ..._prayers.map((p) {
                      final adj = _storage.prayerAdjustment(p['key']!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(p['name']!,
                                  style: const TextStyle(
                                      color: AppTheme.cream)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: AppTheme.muted),
                              onPressed: () async {
                                await _storage.setPrayerAdjustment(
                                    p['key']!, adj - 1);
                                await _alarm.rescheduleAll();
                                setState(() {});
                              },
                            ),
                            Text('$adj',
                                style: const TextStyle(
                                    color: AppTheme.goldSoft, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: AppTheme.muted),
                              onPressed: () async {
                                await _storage.setPrayerAdjustment(
                                    p['key']!, adj + 1);
                                await _alarm.rescheduleAll();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Iqama offsets (minutes after Adhan)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('وقت الإقامة (دقائق بعد الأذان)',
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    ..._prayers.map((p) {
                      final iq = _storage.iqamaOffset(p['key']!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(p['name']!,
                                  style: const TextStyle(
                                      color: AppTheme.cream)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: AppTheme.muted),
                              onPressed: () async {
                                if (iq > 0) {
                                  await _storage.setIqamaOffset(
                                      p['key']!, iq - 1);
                                  setState(() {});
                                }
                              },
                            ),
                            Text('$iq',
                                style: const TextStyle(
                                    color: AppTheme.goldSoft, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: AppTheme.muted),
                              onPressed: () async {
                                await _storage.setIqamaOffset(
                                    p['key']!, iq + 1);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Permissions helper
            Card(
              child: ListTile(
                leading: const Icon(Icons.security, color: AppTheme.gold),
                title: const Text('أذونات التنبيه',
                    style: TextStyle(color: AppTheme.cream)),
                subtitle: const Text(
                    'فعّل الأذونات وتجاهل تحسين البطارية لضمان عمل المنبه',
                    style: TextStyle(color: AppTheme.muted)),
                trailing: const Icon(Icons.chevron_left, color: AppTheme.muted),
                onTap: () async {
                  await _alarm.requestPermissions();
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text('تطبيق منبه الفجر • إصدار 1.0',
                  style: TextStyle(color: AppTheme.muted, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
