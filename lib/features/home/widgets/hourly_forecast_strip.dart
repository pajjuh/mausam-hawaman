import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../data/models/hourly_forecast.dart';
import '../../confidence/confidence_badge.dart';
import '../../../providers/settings_provider.dart';

/// Horizontal scrolling hourly forecast strip with temperature curve (F3)
class HourlyForecastStrip extends ConsumerWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastStrip({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    final settings = ref.watch(settingsProvider);
    final tempUnitStr = settings.tempUnit == 'F' ? '°F' : '°';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                '48-Hour Forecast',
                style: AppTextStyles.labelLarge,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Temperature Curve Chart ──
        SizedBox(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTemperatureChart(settings),
          ),
        ),
        const SizedBox(height: 8),

        // ── Hourly Cards ──
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              return _buildHourCard(context, forecasts[index], index, settings, tempUnitStr);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureChart(SettingsState settings) {
    // Show every 3rd point for readability
    final spots = <FlSpot>[];
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;

    for (var i = 0; i < forecasts.length; i++) {
      final rawTemp = forecasts[i].temperature;
      final temp = UnitConverter.convertTemp(rawTemp, settings.tempUnit).toDouble();
      
      spots.add(FlSpot(i.toDouble(), temp));
      if (temp < minTemp) minTemp = temp;
      if (temp > maxTemp) maxTemp = temp;
    }

    final range = maxTemp - minTemp;
    final padding = range < 5 ? 3.0 : range * 0.2;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minY: minTemp - padding,
        maxY: maxTemp + padding,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final forecast = forecasts[spot.x.toInt()];
                final temp = UnitConverter.convertTemp(forecast.temperature, settings.tempUnit);
                final unitStr = settings.tempUnit == 'F' ? '°F' : '°';
                return LineTooltipItem(
                  '$temp$unitStr · ${DateFormatter.shortTime(forecast.time)}',
                  AppTextStyles.labelSmall.copyWith(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourCard(BuildContext context, HourlyForecast forecast, int index, SettingsState settings, String tempUnitStr) {
    final isNow = DateFormatter.isCurrentHour(forecast.time);
    final hasRain = forecast.precipitationProbability > 30;
    
    final tempValue = UnitConverter.convertTemp(forecast.temperature, settings.tempUnit);

    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isNow ? AppColors.primarySurface : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNow ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
          width: isNow ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Time
            Text(
              isNow ? 'Now' : DateFormatter.shortTime(forecast.time),
              style: AppTextStyles.labelSmall.copyWith(
                color: isNow ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isNow ? FontWeight.w700 : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),

            // Weather Icon
            Icon(
              WeatherUtils.getIcon(
                  forecast.weatherCode, isDay: forecast.isDay),
              size: 24,
              color: WeatherUtils.getColor(forecast.weatherCode),
            ),

            // Temperature
            Text(
              '$tempValue$tempUnitStr',
              style: AppTextStyles.labelLarge.copyWith(
                color: isNow ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),

            // Rain probability
            if (hasRain) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop_rounded,
                      size: 10, color: AppColors.rainMedium),
                  const SizedBox(width: 2),
                  Text(
                    '${forecast.precipitationProbability}%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.rainMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ConfidenceBadge(confidence: forecast.confidence),
            ] else
              const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
