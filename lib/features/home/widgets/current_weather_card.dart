import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/current_weather.dart';
import '../../../data/models/daily_forecast.dart';
import '../../../data/models/location_data.dart';

/// Large hero card showing current weather conditions (F2)
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;
  final LocationData location;
  final DailyForecast? todayForecast;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.location,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: weather.isDay
            ? AppColors.skyGradient
            : AppColors.nightGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Location & Time ──
            _buildHeader(),
            const SizedBox(height: 20),

            // ── Temperature ──
            _buildTemperature(context),
            const SizedBox(height: 8),

            // ── Weather Condition ──
            _buildCondition(),
            const SizedBox(height: 24),

            // ── Detail Chips ──
            _buildDetailRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location.shortDisplayName,
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
          ),
        ),
        Text(
          'Updated ${DateFormatter.timeAgo(weather.time)}',
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white60),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTemperature(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature.round()}°',
                style: AppTextStyles.temperature.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                'Feels like ${weather.feelsLike.round()}°',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        Icon(
          WeatherUtils.getIcon(weather.weatherCode, isDay: weather.isDay),
          size: 72,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ],
    );
  }

  Widget _buildCondition() {
    final description = WeatherUtils.getDescription(weather.weatherCode);
    final highLow = todayForecast != null
        ? ' · H:${todayForecast!.tempMax.round()}° L:${todayForecast!.tempMin.round()}°'
        : '';

    return Text(
      '$description$highLow',
      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 1,
    );
  }

  Widget _buildDetailRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _detailChip(
              Icons.water_drop_outlined,
              '${weather.humidity}%',
              'Humidity',
            ),
            _detailChip(
              Icons.air_rounded,
              '${weather.windSpeed.round()} km/h',
              WeatherUtils.getWindDirection(weather.windDirection),
            ),
            if (weather.visibility != null)
              _detailChip(
                Icons.visibility_outlined,
                '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
                'Visibility',
              ),
            if (weather.pressure != null)
              _detailChip(
                Icons.speed_rounded,
                '${weather.pressure!.round()} hPa',
                'Pressure',
              ),
          ],
        );
      },
    );
  }

  Widget _detailChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white60,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
