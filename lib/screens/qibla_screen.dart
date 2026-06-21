import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';

import '../services/storage_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Qibla compass: shows the direction to the Kaaba from the saved location.
/// The bearing comes from the adhan package; the live heading comes from the
/// device magnetometer via flutter_compass.
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final StorageService _storage = StorageService();
  late final double _qibla;

  @override
  void initState() {
    super.initState();
    final coords = Coordinates(_storage.latitude, _storage.longitude);
    _qibla = Qibla(coords).direction;
  }

  // Normalize an angle to the range [-180, 180].
  double _normalize(double deg) {
    double d = deg % 360;
    if (d > 180) d -= 360;
    if (d < -180) d += 360;
    return d;
  }

  Widget _message(String text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.cream, fontSize: 16),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('qibla_direction'))),
      body: SafeArea(
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _message(tr('compass_read_error'));
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.gold),
              );
            }
            final heading = snapshot.data!.heading;
            if (heading == null) {
              return _message(tr('compass_unavailable'));
            }

            final diff = _normalize(_qibla - heading);
            final aligned = diff.abs() < 5;
            final angleRad = diff * math.pi / 180;
            final accent = aligned ? Colors.green : AppTheme.gold;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr('qibla_from_location'),
                      style:
                          TextStyle(color: AppTheme.muted, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text('${_qibla.toStringAsFixed(0)}°',
                      style: const TextStyle(
                          color: AppTheme.goldSoft,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dial
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.navyCard,
                            border: Border.all(
                                color: accent.withOpacity(0.7), width: 3),
                          ),
                        ),
                        // North letter rotates with the world
                        Transform.rotate(
                          angle: -heading * math.pi / 180,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(tr('north_letter'),
                                  style: TextStyle(
                                      color: AppTheme.muted,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        // Fixed reference at the top (where the phone points)
                        const Align(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.arrow_drop_down,
                              color: AppTheme.muted, size: 36),
                        ),
                        // Qibla arrow
                        Transform.rotate(
                          angle: angleRad,
                          child: Icon(Icons.navigation, color: accent, size: 110),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Text(
                    aligned
                        ? tr('facing_qibla')
                        : tr('turn_phone_arrow'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: aligned ? Colors.green : AppTheme.cream,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      trp('current_heading',
                          {'d': heading.toStringAsFixed(0)}),
                      style:
                          TextStyle(color: AppTheme.muted, fontSize: 13)),
                  const SizedBox(height: 18),
                  Text(tr('calibrate_hint'),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppTheme.muted, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
