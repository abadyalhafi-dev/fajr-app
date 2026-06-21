import 'dart:async';
import 'package:flutter/material.dart';
import '../services/prayer_service.dart';
import '../services/storage_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Shows a live countdown to Iqama, but only during the window between an
/// Adhan and its Iqama (Adhan time + per-prayer offset). Hidden otherwise.
class IqamaCountdownCard extends StatefulWidget {
  const IqamaCountdownCard({super.key});

  @override
  State<IqamaCountdownCard> createState() => _IqamaCountdownCardState();
}

class _IqamaCountdownCardState extends State<IqamaCountdownCard> {
  final PrayerService _prayer = PrayerService();
  final StorageService _storage = StorageService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Returns the active prayer whose Iqama is still pending, or null.
  PrayerSlot? _activePrayer(DateTime now) {
    for (final p in _prayer.todaysPrayers()) {
      final offset = _storage.iqamaOffset(p.key);
      final iqamaTime = p.time.add(Duration(minutes: offset));
      if (now.isAfter(p.time) && now.isBefore(iqamaTime)) {
        return p;
      }
    }
    return null;
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final active = _activePrayer(now);
    if (active == null) return const SizedBox.shrink();

    final offset = _storage.iqamaOffset(active.key);
    final iqamaTime = active.time.add(Duration(minutes: offset));
    final remaining = iqamaTime.difference(now);
    final m = remaining.inMinutes;
    final s = remaining.inSeconds % 60;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.gold.withOpacity(0.12),
        border: Border.all(color: AppTheme.gold.withOpacity(0.5), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.groups, color: AppTheme.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                  trp('iqama_after', {'name': tr('prayer_${active.key}')}),
                  style: const TextStyle(
                      color: AppTheme.goldSoft,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${_two(m)}:${_two(s)}',
            style: const TextStyle(
              color: AppTheme.cream,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
