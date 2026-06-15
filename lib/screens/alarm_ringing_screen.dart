import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../services/storage_service.dart';
import '../widgets/mosque_logo.dart';
import '../theme/app_theme.dart';

/// Full-screen alarm that rings until the user force-dismisses it.
class AlarmRingingScreen extends StatefulWidget {
  final bool isMain; // true = main adhan, false = pre-alarm
  final String prayerName;

  const AlarmRingingScreen({
    super.key,
    required this.isMain,
    required this.prayerName,
  });

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen> {
  final AudioPlayer _player = AudioPlayer();
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _startSound();
  }

  Future<void> _startSound() async {
    final path = widget.isMain
        ? _storage.fajrSoundPath
        : _storage.preAlarmSoundPath;

    await _player.setReleaseMode(ReleaseMode.loop); // keep ringing
    try {
      if (path != null) {
        await _player.play(DeviceFileSource(path));
      } else {
        // Fallback tone bundled in assets if user hasn't picked a sound.
        await _player.play(AssetSource('sounds/default_alarm.wav'));
      }
    } catch (_) {
      // If playback fails, the on-screen UI + system notification still alert.
    }
  }

  Future<void> _dismiss() async {
    await _player.stop();
    await _player.release();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // force the user to use the dismiss button
      child: Scaffold(
        backgroundColor: AppTheme.navy,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    const MosqueLogo(size: 140),
                    const SizedBox(height: 28),
                    Text(
                      widget.isMain
                          ? 'حان وقت ${widget.prayerName}'
                          : 'اقترب وقت ${widget.prayerName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.goldSoft,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isMain ? 'الصلاة خير من النوم' : 'استعد للصلاة',
                      style: const TextStyle(
                          color: AppTheme.cream, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          foregroundColor: AppTheme.navy,
                          padding:
                              const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _dismiss,
                        child: const Text('إيقاف',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
