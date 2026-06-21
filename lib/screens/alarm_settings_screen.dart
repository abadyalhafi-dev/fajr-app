import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../services/storage_service.dart';
import '../services/alarm_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

class AlarmSettingsScreen extends StatefulWidget {
  const AlarmSettingsScreen({super.key});

  @override
  State<AlarmSettingsScreen> createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  final StorageService _storage = StorageService();
  final AlarmService _alarm = AlarmService();

  // All five prayers, each individually toggleable. Fajr defaults ON.
  final List<String> _prayerKeys = const [
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  Future<void> _pickSound({required bool isMain}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null || result.files.single.path == null) return;

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
    if (path == null) return tr('not_selected');
    return path.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('alarm_title'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // ---- Prayer alarms (all five, Fajr included) ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(tr('prayers_adhan'),
                          style: TextStyle(
                              color: AppTheme.goldSoft,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    ..._prayerKeys.map((key) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(tr('prayer_$key'),
                              style: const TextStyle(color: AppTheme.cream)),
                          value: _storage.isPrayerAlarmEnabled(key),
                          onChanged: (v) async {
                            await _storage.setPrayerAlarmEnabled(key, v);
                            setState(() {});
                          },
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---- Fajr pre-alarm ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(tr('fajr_prealarm'),
                          style: TextStyle(color: AppTheme.cream)),
                      subtitle: Text(
                          trp('prealarm_before', {'n': ''}),
                          style: const TextStyle(color: AppTheme.muted)),
                      value: _storage.preAlarmEnabled,
                      onChanged: (v) async {
                        await _storage.setPreAlarmEnabled(v);
                        setState(() {});
                      },
                    ),
                    Row(
                      children: [
                        Text(tr('minutes_label'),
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

            // ---- General (vibration) ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary:
                      const Icon(Icons.vibration, color: AppTheme.gold),
                  title: Text(tr('vibration_on_alarm'),
                      style: TextStyle(color: AppTheme.cream)),
                  value: _storage.vibrationEnabled,
                  onChanged: (v) async {
                    await _storage.setVibrationEnabled(v);
                    setState(() {});
                  },
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
                      child: Text(tr('sounds'),
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
                      title: Text(tr('fajr_adhan_sound'),
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
                      title: Text(tr('prealarm_sound'),
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

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _alarm.requestPermissions();
                  await _alarm.rescheduleAll();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr('all_alarms_updated'),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        backgroundColor: Colors.green.shade700,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${tr('error_prefix')}$e',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        backgroundColor: Colors.red.shade700,
                        duration: const Duration(seconds: 8),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(tr('save_update_alarms')),
            ),
          ],
        ),
      ),
    );
  }
}
