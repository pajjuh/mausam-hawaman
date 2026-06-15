import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/hourly_forecast.dart';

enum SprayStatus { safe, marginal, unsafe }

class SprayWindowCard extends StatelessWidget {
  final List<HourlyForecast> forecasts;

  const SprayWindowCard({super.key, required this.forecasts});

  SprayStatus _getSprayStatus(int startIndex) {
    if (startIndex >= forecasts.length) return SprayStatus.unsafe;
    
    final current = forecasts[startIndex];
    
    // Check next 4 hours for rain
    double totalRain = 0;
    for (int i = startIndex; i < startIndex + 4 && i < forecasts.length; i++) {
      totalRain += forecasts[i].precipitation;
    }

    if (totalRain > 0.5 || current.windSpeed > 25 || current.humidity > 90) {
      return SprayStatus.unsafe;
    } else if (totalRain > 0 || current.windSpeed > 15 || current.humidity > 80) {
      return SprayStatus.marginal;
    }
    return SprayStatus.safe;
  }

  Color _getStatusColor(SprayStatus status) {
    switch (status) {
      case SprayStatus.safe:
        return AppColors.success;
      case SprayStatus.marginal:
        return AppColors.warning;
      case SprayStatus.unsafe:
        return AppColors.danger;
    }
  }

  String _getStatusText(SprayStatus status) {
    switch (status) {
      case SprayStatus.safe:
        return 'Safe to Spray';
      case SprayStatus.marginal:
        return 'Spray with Caution';
      case SprayStatus.unsafe:
        return 'Do Not Spray';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show only next 24 hours to keep it clean
    final displayCount = forecasts.length > 24 ? 24 : forecasts.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: constraints.maxWidth,
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
              const Flexible(child: Icon(Icons.water_drop, color: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pesticide Spray Window', 
                  style: AppTextStyles.displaySmall,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on wind, humidity, and upcoming rain in the next 4 hours.',
            style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.outline),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayCount,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final forecast = forecasts[index];
                final status = _getSprayStatus(index);
                
                return Container(
                  width: MediaQuery.of(context).size.width * 0.36,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(status).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('h a').format(forecast.time),
                        style: AppTextStyles.labelLarge,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Icon(
                          status == SprayStatus.safe
                              ? Icons.check_circle_outline
                              : status == SprayStatus.unsafe
                                  ? Icons.cancel_outlined
                                  : Icons.warning_amber_rounded,
                          color: _getStatusColor(status),
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          _getStatusText(status),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
