import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/weather_response.dart';
import 'dio_client.dart';

/// Service to fetch weather data from Open-Meteo API
class WeatherApiService {
  final Dio _dio;

  WeatherApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  /// Fetch current + hourly (48h) + daily (7-day) forecast for a coordinate
  Future<WeatherResponse> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.weatherEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current': ApiConstants.currentParams.join(','),
          'hourly': ApiConstants.hourlyParams.join(','),
          'daily': ApiConstants.dailyParams.join(','),
          'timezone': 'auto',
          'forecast_days': 7,
          'forecast_hours': 48,
          'wind_speed_unit': 'kmh',
          'temperature_unit': 'celsius',
          'models': ApiConstants.confidenceModels.join(','),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch weather: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
          'Weather API error: ${e.message ?? 'Network error'}');
    }
  }
}
