import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Animated 3-bar equalizer waveform displayed during TTS speech.
/// Each bar oscillates at a different phase for a smooth, organic feel.
class VaaniWaveform extends StatefulWidget {
  final Color color;

  const VaaniWaveform({
    super.key,
    this.color = AppColors.primary,
  });

  @override
  State<VaaniWaveform> createState() => _VaaniWaveformState();
}

class _VaaniWaveformState extends State<VaaniWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 48,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WaveformPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  _WaveformPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const barCount = 3;
    final barWidth = size.width * 0.18;
    final gap = (size.width - barCount * barWidth) / (barCount + 1);
    final minHeight = size.height * 0.25;
    final maxHeight = size.height * 0.85;

    for (int i = 0; i < barCount; i++) {
      // Each bar is offset by 120° (2π/3) for a staggered wave
      final phase = progress * 2 * pi + (i * 2 * pi / 3);
      final normalizedHeight = (sin(phase) + 1) / 2; // 0.0 to 1.0
      final barHeight = minHeight + normalizedHeight * (maxHeight - minHeight);

      final x = gap + i * (barWidth + gap);
      final y = (size.height - barHeight) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
