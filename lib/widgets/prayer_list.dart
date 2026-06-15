import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';
import '../theme/app_theme.dart';

/// Today's full prayer list as rows inside a card.
class PrayerList extends StatelessWidget {
  final List<PrayerSlot> prayers;
  final String? highlightKey; // next prayer key to emphasize

  const PrayerList({super.key, required this.prayers, this.highlightKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: [
            for (int i = 0; i < prayers.length; i++) ...[
              _PrayerRow(
                slot: prayers[i],
                highlighted: prayers[i].key == highlightKey,
              ),
              if (i != prayers.length - 1)
                Divider(
                  color: AppTheme.navyLight,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ]
          ],
        ),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final PrayerSlot slot;
  final bool highlighted;
  const _PrayerRow({required this.slot, required this.highlighted});

  IconData get _icon {
    switch (slot.key) {
      case 'fajr':
        return Icons.brightness_3;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.wb_twilight;
      case 'maghrib':
        return Icons.brightness_4;
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(slot.time);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: highlighted ? AppTheme.gold.withOpacity(0.10) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_icon,
              color: highlighted ? AppTheme.gold : AppTheme.muted, size: 22),
          const SizedBox(width: 14),
          Text(
            slot.arabicName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
              color: highlighted ? AppTheme.goldSoft : AppTheme.cream,
            ),
          ),
          const Spacer(),
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 17,
              color: highlighted ? AppTheme.goldSoft : AppTheme.cream,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
