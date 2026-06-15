import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/weather_response.dart';
import '../remote/weather_api_service.dart';
import '../../core/constants/app_constants.dart';

/// Repository coordinating weather data between API and local cache
class WeatherRepository {
  final WeatherApiService _apiService;
  final AppDatabase _db;

  WeatherRepository({
    required WeatherApiService apiService,
    required AppDatabase db,
  })  : _apiService = apiService,
        _db = db;

  /// Fetch weather for a location.
  /// Returns cached data if fresh enough, otherwise fetches from API.
  Future<WeatherResponse> getWeather({
    required int locationId,
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    // Check cache first (unless force refresh)
    if (!forceRefresh) {
      final cached = await _getCachedWeather(locationId);
      if (cached != null) return cached;
    }

    // Fetch from API
    final weather = await _apiService.getWeather(
      latitude: latitude,
      longitude: longitude,
    );

    // Cache the result
    await _cacheWeather(locationId, weather);

    // Cleanup old entries
    await _db.deleteOldForecasts(
        const Duration(hours: 24));

    return weather;
  }

  /// Try to get cached weather if it's still fresh
  Future<WeatherResponse?> _getCachedWeather(int locationId) async {
    final forecast = await _db.getLatestForecast(locationId);
    if (forecast == null) return null;

    final age = DateTime.now().difference(forecast.fetchedAt);
    if (age > AppConstants.cacheExpiry) return null;

    try {
      final hourlyData =
          jsonDecode(forecast.hourlyJson) as Map<String, dynamic>;
      final dailyData =
          jsonDecode(forecast.dailyJson) as Map<String, dynamic>;

      // Reconstruct a minimal response from cache
      return WeatherResponse.fromJson({
        'current': hourlyData['current'] ?? {},
        'hourly': hourlyData,
        'daily': dailyData,
        'latitude': 0.0,
        'longitude': 0.0,
        'timezone': 'auto',
      });
    } catch (_) {
      return null;
    }
  }

  /// Cache weather data to Drift
  Future<void> _cacheWeather(
      int locationId, WeatherResponse weather) async {
    await _db.insertForecast(WeatherForecastsCompanion(
      locationId: Value(locationId),
      fetchedAt: Value(DateTime.now()),
      model: const Value('open_meteo'),
      hourlyJson: Value(jsonEncode({
        'current': {
          'temperature_2m': weather.current.temperature,
          'apparent_temperature': weather.current.feelsLike,
          'relative_humidity_2m': weather.current.humidity,
          'weather_code': weather.current.weatherCode,
          'wind_speed_10m': weather.current.windSpeed,
          'wind_direction_10m': weather.current.windDirection,
          'surface_pressure': weather.current.pressure,
          'visibility': weather.current.visibility,
          'is_day': weather.current.isDay ? 1 : 0,
          'time': weather.current.time.toIso8601String(),
        },
        'time': weather.hourly
            .map((h) => h.time.toIso8601String())
            .toList(),
        'temperature_2m':
            weather.hourly.map((h) => h.temperature).toList(),
        'apparent_temperature':
            weather.hourly.map((h) => h.feelsLike).toList(),
        'relative_humidity_2m':
            weather.hourly.map((h) => h.humidity).toList(),
        'precipitation_probability':
            weather.hourly.map((h) => h.precipitationProbability).toList(),
        'precipitation':
            weather.hourly.map((h) => h.precipitation).toList(),
        'weather_code':
            weather.hourly.map((h) => h.weatherCode).toList(),
        'wind_speed_10m':
            weather.hourly.map((h) => h.windSpeed).toList(),
        'wind_gusts_10m':
            weather.hourly.map((h) => h.windGusts).toList(),
        'visibility':
            weather.hourly.map((h) => h.visibility).toList(),
        'uv_index':
            weather.hourly.map((h) => h.uvIndex).toList(),
        'is_day':
            weather.hourly.map((h) => h.isDay ? 1 : 0).toList(),
      })),
      dailyJson: Value(jsonEncode({
        'time': weather.daily
            .map((d) => d.date.toIso8601String().split('T').first)
            .toList(),
        'weather_code':
            weather.daily.map((d) => d.weatherCode).toList(),
        'temperature_2m_max':
            weather.daily.map((d) => d.tempMax).toList(),
        'temperature_2m_min':
            weather.daily.map((d) => d.tempMin).toList(),
        'apparent_temperature_max':
            weather.daily.map((d) => d.feelsLikeMax).toList(),
        'apparent_temperature_min':
            weather.daily.map((d) => d.feelsLikeMin).toList(),
        'precipitation_sum':
            weather.daily.map((d) => d.precipitationSum).toList(),
        'precipitation_probability_max':
            weather.daily.map((d) => d.precipitationProbabilityMax).toList(),
        'wind_speed_10m_max':
            weather.daily.map((d) => d.windSpeedMax).toList(),
        'sunrise': weather.daily
            .map((d) => d.sunrise?.toIso8601String())
            .toList(),
        'sunset': weather.daily
            .map((d) => d.sunset?.toIso8601String())
            .toList(),
        'uv_index_max':
            weather.daily.map((d) => d.uvIndexMax).toList(),
      })),
    ));
  }
}
