import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';

import '../services/storage_service.dart';
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
      appBar: AppBar(title: const Text('اتجاه القبلة')),
      body: SafeArea(
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _message('تعذّر قراءة البوصلة على هذا الجهاز');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.gold),
              );
            }
            final heading = snapsho
