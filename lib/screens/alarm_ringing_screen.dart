import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alarm/alarm.dart';

import '../widgets/mosque_logo.dart';
import '../theme/app_theme.dart';

/// Full-screen UI shown while an alarm rings. The `alarm` package plays the
/// sound; this screen shows the message and a stop button. A volume-button
/// press (forwarded from native MainActivity) also dismisses the alarm.
class AlarmRingingScreen extends StatefulWidget {
  final int alarmId;
  final bool isMain;
  final String prayerName;

  const AlarmRingingScreen({
    super.key,
    required this.alarmId,
    required this.isMain,
    required this.prayerName,
  });

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen> {
  static const _channel = MethodChannel('fajr_app/volume');
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    // While this screen is shown, a volume key press dismisses the alarm.
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'volumeButtonPressed') {
        await _dismiss();
      }
    });
  }

  @override
  void dispose() {
    // Stop listening once the screen is gone, so volume keys work normally.
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_dismissed) return;
    _dismissed = true;
    await Alarm.stop(widget.alarmId);
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.alarmBg,
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
                        color: AppTheme.alarmAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isMain ? 'الصلاة خير من النوم' : 'استعد للصلاة',
                      style:
                          const TextStyle(color: AppTheme.alarmText, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'اضغط زر الصوت أو إيقاف لإيقاف المنبه',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.alarmMuted, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.alarmAccent,
                      foregroundColor: AppTheme.alarmBg,
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
