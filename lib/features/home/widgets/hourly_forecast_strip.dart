import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/hourly_forecast.dart';

/// Horizontal scrolling hourly forecast strip with temperature curve (F3)
class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastStrip({super.key, required this.forecasts});

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
              const Icon(Icons.schedule_rounded,
                  size: 18, color: AppColors.textSecondary),
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
            child: _buildTemperatureChart(),
          ),
        ),
        const SizedBox(height: 8),

        // ── Hourly Cards ──
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: forecasts.length,
            itemBuilder: (context, index) =>
                _buildHourCard(forecasts[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureChart() {
    // Show every 3rd point for readability
    final spots = <FlSpot>[];
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;

    for (var i = 0; i < forecasts.length; i++) {
      final temp = forecasts[i].temperature;
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
                return LineTooltipItem(
                  '${forecast.temperature.round()}° · ${DateFormatter.shortTime(forecast.time)}',
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

  Widget _buildHourCard(HourlyForecast forecast, int index) {
    final isNow = DateFormatter.isCurrentHour(forecast.time);
    final hasRain = forecast.precipitationProbability > 30;

    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isNow ? AppColors.primarySurface : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNow ? AppColors.primary : AppColors.border,
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
                color: isNow ? AppColors.primary : AppColors.textSecondary,
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
              '${forecast.temperature.round()}°',
              style: AppTextStyles.labelLarge.copyWith(
                color: isNow ? AppColors.primary : AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),

            // Rain probability
            if (hasRain)
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
              )
            else
              const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
