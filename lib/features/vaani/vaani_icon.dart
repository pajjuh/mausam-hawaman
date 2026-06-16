import 'dart:math';
import 'package:flutter/material.dart';

/// Custom icon: sound waves merging into a raindrop shape.
/// Drawn via CustomPainter — zero dependency, scalable to any size.
class VaaniIcon extends StatelessWidget {
  final Color color;
  final double size;

  const VaaniIcon({
    super.key,
    this.color = Colors.white,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VaaniIconPainter(color: color),
      ),
    );
  }
}

class _VaaniIconPainter extends CustomPainter {
  final Color color;

  _VaaniIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // ── Sound wave arcs (left side) ──
    // Center point for arcs — slightly left-of-center
    final arcCenterX = w * 0.30;
    final arcCenterY = h * 0.42;

    // 3 concentric arcs radiating to the right
    for (int i = 0; i < 3; i++) {
      final radius = w * (0.12 + i * 0.10);
      final rect = Rect.fromCircle(
        center: Offset(arcCenterX, arcCenterY),
        radius: radius,
      );
      // Draw quarter-arc facing right (from -45° to +45°)
      canvas.drawArc(rect, -pi / 4, pi / 2, false, paint);
    }

    // ── Raindrop shape (right side) ──
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dropPath = Path();
    // Raindrop tip at top-right
    final tipX = w * 0.82;
    final tipY = h * 0.18;
    // Raindrop body center
    final bodyX = w * 0.78;
    final bodyY = h * 0.62;
    final bodyRadius = w * 0.18;

    // Start at the tip
    dropPath.moveTo(tipX, tipY);
    // Curve down to the left side of the body
    dropPath.quadraticBezierTo(
      bodyX - bodyRadius * 0.6, bodyY - bodyRadius * 0.5,
      bodyX - bodyRadius * 0.85, bodyY + bodyRadius * 0.1,
    );
    // Round bottom arc
    dropPath.arcToPoint(
      Offset(bodyX + bodyRadius * 0.85, bodyY + bodyRadius * 0.1),
      radius: Radius.circular(bodyRadius),
      clockwise: false,
    );
    // Curve back up to the tip
    dropPath.quadraticBezierTo(
      bodyX + bodyRadius * 0.6, bodyY - bodyRadius * 0.5,
      tipX, tipY,
    );
    dropPath.close();

    canvas.drawPath(dropPath, fillPaint);

    // Small highlight dot inside the drop
    final highlightPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(bodyX - bodyRadius * 0.25, bodyY + bodyRadius * 0.15),
      bodyRadius * 0.18,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _VaaniIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
