import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/hourly_forecast.dart';

class ConfidenceBadge extends StatelessWidget {
  final ForecastConfidence confidence;

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;

    switch (confidence) {
      case ForecastConfidence.high:
        color = AppColors.success;
        text = 'HIGH';
        break;
      case ForecastConfidence.medium:
        color = AppColors.warning;
        text = 'MEDIUM';
        break;
      case ForecastConfidence.low:
        color = AppColors.danger;
        text = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
