import 'current_weather.dart';
import 'hourly_forecast.dart';
import 'daily_forecast.dart';

/// Complete weather response combining current, hourly, and daily data
class WeatherResponse {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final double latitude;
  final double longitude;
  final String timezone;
  final DateTime fetchedAt;

  const WeatherResponse({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.fetchedAt,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: CurrentWeather.fromJson(
          json['current'] as Map<String, dynamic>? ?? {}),
      hourly: HourlyForecast.fromJson(
          json['hourly'] as Map<String, dynamic>? ?? {}),
      daily: DailyForecast.fromJson(
          json['daily'] as Map<String, dynamic>? ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      timezone: json['timezone']?.toString() ?? 'auto',
      fetchedAt: DateTime.now(),
    );
  }
}
