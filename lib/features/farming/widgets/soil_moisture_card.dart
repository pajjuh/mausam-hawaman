import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/daily_forecast.dart';

class SoilMoistureCard extends StatelessWidget {
  final DailyForecast? daily;

  const SoilMoistureCard({super.key, this.daily});

  String _getMoistureLevel() {
    if (daily == null) return 'Unknown';
    if (daily!.precipitationSum > 20) return 'Waterlogged';
    if (daily!.precipitationSum > 5) return 'High';
    if (daily!.precipitationSum > 1) return 'Medium';
    return 'Low';
  }

  String _getRecommendation(String level) {
    switch (level) {
      case 'Waterlogged':
        return 'Ensure proper field drainage. Do not irrigate.';
      case 'High':
        return 'No irrigation needed today.';
      case 'Medium':
        return 'Monitor levels. Light irrigation if crop is in critical stage.';
      case 'Low':
        return 'Irrigation highly recommended to prevent crop stress.';
      default:
        return 'Data unavailable';
    }
  }

  Color _getLevelColor(BuildContext context, String level) {
    switch (level) {
      case 'Waterlogged':
        return AppColors.primary;
      case 'High':
        return AppColors.success;
      case 'Medium':
        return AppColors.warning;
      case 'Low':
        return AppColors.danger;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = _getMoistureLevel();
    final recommendation = _getRecommendation(level);
    final color = _getLevelColor(context, level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grass_rounded, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Soil Moisture Estimate',
                  style: AppTextStyles.displaySmall,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.water, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Level: $level',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation,
                      style: AppTextStyles.bodyMedium,
                      softWrap: true,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
