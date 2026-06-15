import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_forecast.dart';

/// 7-day daily forecast list (F4)
class DailyForecastCard extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastCard({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                '7-Day Forecast',
                style: AppTextStyles.labelLarge,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Day Rows ──
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Column(
            children: List.generate(forecasts.length, (index) {
              final isLast = index == forecasts.length - 1;
              return Column(
                children: [
                  _buildDayRow(context, forecasts[index]),
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 16, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDayRow(BuildContext context, DailyForecast forecast) {
    final hasRain = forecast.precipitationProbabilityMax > 30;

    // Find the overall temp range for the bar chart
    double overallMin = double.infinity;
    double overallMax = double.negativeInfinity;
    for (final f in forecasts) {
      if (f.tempMin < overallMin) overallMin = f.tempMin;
      if (f.tempMax > overallMax) overallMax = f.tempMax;
    }
    final range = overallMax - overallMin;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 52,
            child: Text(
              DateFormatter.relativeDay(forecast.date),
              style: AppTextStyles.labelLarge,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),

          // Weather icon
          Icon(
            WeatherUtils.getIcon(forecast.weatherCode),
            size: 22,
            color: WeatherUtils.getColor(forecast.weatherCode),
          ),
          const SizedBox(width: 8),

          // Rain probability (if any)
          SizedBox(
            width: 40,
            child: hasRain
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.water_drop_rounded,
                          size: 10, color: AppColors.rainMedium),
                      const SizedBox(width: 2),
                      Text(
                        '${forecast.precipitationProbabilityMax}%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.rainMedium,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // Min temp
          SizedBox(
            width: 32,
            child: Text(
              '${forecast.tempMin.round()}°',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),

          // Temperature range bar
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                final leftFrac = range > 0
                    ? (forecast.tempMin - overallMin) / range
                    : 0.0;
                final rightFrac = range > 0
                    ? (overallMax - forecast.tempMax) / range
                    : 0.0;

                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: barWidth * leftFrac,
                        right: barWidth * rightFrac,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              WeatherUtils.getTemperatureColor(
                                  forecast.tempMin),
                              WeatherUtils.getTemperatureColor(
                                  forecast.tempMax),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),

          // Max temp
          SizedBox(
            width: 32,
            child: Text(
              '${forecast.tempMax.round()}°',
              style: AppTextStyles.labelLarge,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
