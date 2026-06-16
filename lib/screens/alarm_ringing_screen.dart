import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

import '../widgets/mosque_logo.dart';
import '../theme/app_theme.dart';

/// Full-screen UI shown while an alarm rings. The `alarm` package plays the
/// sound natively; this screen just shows the message and a stop button.
class AlarmRingingScreen extends StatelessWidget {
  final int alarmId;
  final bool isMain;
  final String prayerName;

  const AlarmRingingScreen({
    super.key,
    required this.alarmId,
    required this.isMain,
    required this.prayerName,
  });

  Future<void> _dismiss(BuildContext context) async {
    await Alarm.stop(alarmId);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                      isMain ? 'حان وقت $prayerName' : 'اقترب وقت $prayerName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.goldSoft,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isMain ? 'الصلاة خير من النوم' : 'استعد للصلاة',
                      style:
                          const TextStyle(color: AppTheme.cream, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.navy,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => _dismiss(context),
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
