import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A clean geometric mosque silhouette with a sunrise behind it.
/// Drawn as vector (CustomPainter) so it scales crisply at any size.
class MosqueLogo extends StatelessWidget {
  final double size;
  const MosqueLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MosquePainter()),
    );
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ---- Circular background ----
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.navyLight, AppTheme.navy],
      ).createShader(bgRect);
    canvas.save();
    final clip = Path()..addOval(bgRect);
    canvas.clipPath(clip);
    canvas.drawRect(bgRect, bgPaint);

    // ---- Sunrise (gold arcs) ----
    final sunCenter = Offset(w * 0.5, h * 0.62);
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.gold, AppTheme.gold.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: w * 0.42));
    canvas.drawCircle(sunCenter, w * 0.42, sunPaint);

    // Sun disc
    final discPaint = Paint()..color = AppTheme.goldSoft;
    canvas.drawCircle(sunCenter, w * 0.14, discPaint);

    // ---- Mosque silhouette ----
    final mosque = Paint()..color = AppTheme.navy.withOpacity(0.95);
    final cx = w * 0.5;

    // Main dome
    final domeRect = Rect.fromCircle(center: Offset(cx, h * 0.60), radius: w * 0.16);
    final domePath = Path()
      ..addArc(domeRect, 3.14159, 3.14159); // top half
    // pointed top of dome
    domePath.moveTo(cx, h * 0.60 - w * 0.16);
    domePath.lineTo(cx - w * 0.02, h * 0.60 - w * 0.22);
    domePath.lineTo(cx, h * 0.60 - w * 0.27);
    domePath.lineTo(cx + w * 0.02, h * 0.60 - w * 0.22);
    domePath.close();
    canvas.drawPath(domePath, mosque);

    // Building body
    final body = Rect.fromLTWH(cx - w * 0.20, h * 0.60, w * 0.40, h * 0.18);
    canvas.drawRect(body, mosque);

    // Two minarets
    void minaret(double mx) {
      final rect = Rect.fromLTWH(mx - w * 0.025, h * 0.42, w * 0.05, h * 0.36);
      canvas.drawRect(rect, mosque);
      // minaret cap
      final cap = Path()
        ..moveTo(mx - w * 0.03, h * 0.42)
        ..lineTo(mx, h * 0.36)
        ..lineTo(mx + w * 0.03, h * 0.42)
        ..close();
      canvas.drawPath(cap, mosque);
      // small ball
      canvas.drawCircle(Offset(mx, h * 0.355), w * 0.012, mosque);
    }

    minaret(cx - w * 0.27);
    minaret(cx + w * 0.27);

    // Crescent on main dome
    final crescentPaint = Paint()..color = AppTheme.goldSoft;
    final crescentCenter = Offset(cx, h * 0.30);
    final outer = Path()
      ..addOval(Rect.fromCircle(center: crescentCenter, radius: w * 0.035));
    final inner = Path()
      ..addOval(Rect.fromCircle(
          center: crescentCenter.translate(w * 0.015, 0), radius: w * 0.03));
    final crescent =
        Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(crescent, crescentPaint);

    // Gold baseline under building
    final basePaint = Paint()
      ..color = AppTheme.gold
      ..strokeWidth = h * 0.012;
    canvas.drawLine(
      Offset(w * 0.12, h * 0.78),
      Offset(w * 0.88, h * 0.78),
      basePaint,
    );

    canvas.restore();

    // Gold ring border
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.02
      ..color = AppTheme.gold.withOpacity(0.8);
    canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - h * 0.01, ring);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
