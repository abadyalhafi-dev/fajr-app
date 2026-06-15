import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';
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
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _refresh() {
    _next = _prayer.nextPrayer();
    _tick();
  }

  void _tick() {
    if (_next == null) return;
    final now = DateTime.now();
    var diff = _next!.time.difference(now);
    if (diff.isNegative) {
      _refresh();
      return;
    }
    setState(() => _remaining = diff);
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
          Text('الصلاة القادمة',
              style: TextStyle(color: AppTheme.muted, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            _next?.arabicName ?? '—',
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
          Text('الوقت المتبقي',
              style: TextStyle(color: AppTheme.muted, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            '${_two(h)}:${_two(m)}:${_two(s)}',
            style: const TextStyle(
              color: AppTheme.cream,
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
