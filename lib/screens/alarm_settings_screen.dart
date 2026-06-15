import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../services/storage_service.dart';
import '../services/alarm_service.dart';
import '../theme/app_theme.dart';

class AlarmSettingsScreen extends StatefulWidget {
  const AlarmSettingsScreen({super.key});

  @override
  State<AlarmSettingsScreen> createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  final StorageService _storage = StorageService();
  final AlarmService _alarm = AlarmService();

  // Prayers that can be toggled (Fajr is fixed ON).
  final List<Map<String, String>> _otherPrayers = const [
    {'key': 'dhuhr', 'name': 'الظهر'},
    {'key': 'asr', 'name': 'العصر'},
    {'key': 'maghrib', 'name': 'المغرب'},
    {'key': 'isha', 'name': 'العشاء'},
  ];

  Future<void> _pickSound({required bool isMain}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null || result.files.single.path == null) return;

    // Copy into app storage so the path stays stable.
    final src = File(result.files.single.path!);
    final dir = await getApplicationDocumentsDirectory();
    final name = isMain ? 'fajr_adhan' : 'pre_alarm';
    final ext = result.files.single.extension ?? 'mp3';
    final dest = File('${dir.path}/$name.$ext');
    await src.copy(dest.path);

    if (isMain) {
      await _storage.setFajrSound(dest.path);
    } else {
      await _storage.setPreAlarmSound(dest.path);
    }
    setState(() {});
  }

  String _fileName(String? path) {
    if (path == null) return 'لم يتم الاختيار';
    return path.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنبه')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // ---- Fajr (always on) ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.brightness_3, color: AppTheme.gold),
                        const SizedBox(width: 10),
                        const Text('الفجر',
                            style: TextStyle(
                                color: AppTheme.goldSoft,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('مفعّل دائمًا',
                              style: TextStyle(
                                  color: AppTheme.goldSoft, fontSize: 12)),
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.navyLight, height: 24),
                    // Pre-alarm toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('التنبيه المبكر',
                          style: TextStyle(color: AppTheme.cream)),
                      subtitle: Text(
                          'قبل ${_storage.preAlarmMinutes} دقيقة من الفجر',
                          style: const TextStyle(color: AppTheme.muted)),
                      value: _storage.preAlarmEnabled,
                      onChanged: (v) async {
                        await _storage.setPreAlarmEnabled(v);
                        setState(() {});
                      },
                    ),
                    // Minutes slider
                    Row(
                      children: [
                        const Text('الدقائق:',
                            style: TextStyle(color: AppTheme.muted)),
                        Expanded(
                          child: Slider(
                            min: 5,
                            max: 45,
                            divisions: 8,
                            activeColor: AppTheme.gold,
                            label: '${_storage.preAlarmMinutes}',
                            value: _storage.preAlarmMinutes.toDouble(),
                            onChanged: (v) async {
                              await _storage.setPreAlarmMinutes(v.round());
                              setState(() {});
                            },
                          ),
                        ),
                        Text('${_storage.preAlarmMinutes}',
                            style: const TextStyle(color: AppTheme.goldSoft)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---- Sounds ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('الأصوات',
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                          const Icon(Icons.volume_up, color: AppTheme.gold),
                      title: const Text('صوت أذان الفجر',
                          style: TextStyle(color: AppTheme.cream)),
                      subtitle: Text(_fileName(_storage.fajrSoundPath),
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 12)),
                      trailing: const Icon(Icons.folder_open,
                          color: AppTheme.muted),
                      onTap: () => _pickSound(isMain: true),
                    ),
                    const Divider(color: AppTheme.navyLight),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.notifications_active,
                          color: AppTheme.gold),
                      title: const Text('صوت التنبيه المبكر',
                          style: TextStyle(color: AppTheme.cream)),
                      subtitle: Text(_fileName(_storage.preAlarmSoundPath),
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 12)),
                      trailing: const Icon(Icons.folder_open,
                          color: AppTheme.muted),
                      onTap: () => _pickSound(isMain: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---- Other prayers ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('باقي الصلوات',
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    ..._otherPrayers.map((p) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(p['name']!,
                              style: const TextStyle(color: AppTheme.cream)),
                          value: _storage.isPrayerAlarmEnabled(p['key']!),
                          onChanged: (v) async {
                            await _storage.setPrayerAlarmEnabled(
                                p['key']!, v);
                            setState(() {});
                          },
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _alarm.requestPermissions();
                  await _alarm.rescheduleAll();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تحديث جميع التنبيهات'),
                        backgroundColor: AppTheme.navyLight,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 8),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('حفظ وتحديث التنبيهات'),
            ),
          ],
        ),
      ),
    );
  }
}
