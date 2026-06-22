import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Big hero card: shows the next prayer + a live countdown.
class CountdownCard extends StatefulWidget {
  const CountdownCard({super.key});

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  final PrayerService _prayer = PrayerService();
  Timer? _timer;
  PrayerSlot? _next;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    // Recompute the next prayer every tick so the countdown stays correct
    // even if the clock changes or the user switches city/location.
    final next = _prayer.nextPrayer();
    final now = DateTime.now();
    var diff = next == null ? Duration.zero : next.time.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    if (!mounted) return;
    setState(() {
      _next = next;
      _remaining = diff;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    final timeStr = _next == null
        ? '--:--'
        : DateFormat('h:mm a').format(_next!.time);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppTheme.navyLight, AppTheme.navyCard],
        ),
        border: Border.all(color: AppTheme.gold.withOpacity(0.35), width: 1.2),
      ),
      child: Column(
        children: [
          Text(tr('next_prayer'),
              style: TextStyle(color: AppTheme.muted, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            _next == null ? '—' : tr('prayer_${_next!.key}'),
            style: const TextStyle(
              color: AppTheme.goldSoft,
              fontSize: 38,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(timeStr,
              style: const TextStyle(color: AppTheme.cream, fontSize: 18)),
          const SizedBox(height: 18),
          Text(tr('remaining_time'),
              style: TextStyle(color: AppTheme.muted, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            '${_two(h)}:${_two(m)}:${_two(s)}',
            style: const TextStyle(
              color: AppTheme.amber,
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
