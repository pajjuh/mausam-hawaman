import 'dart:math';
import 'package:collection/collection.dart';
import '../../core/constants/api_constants.dart';

enum ForecastConfidence { high, medium, low }

/// Single hour of forecast data from Open-Meteo
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int precipitationProbability;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final double windGusts;
  final double? visibility;
  final double? uvIndex;
  final bool isDay;
  final ForecastConfidence confidence;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.precipitationProbability,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.windGusts,
    this.visibility,
    this.uvIndex,
    required this.isDay,
    this.confidence = ForecastConfidence.high,
  });

  /// Parse the Open-Meteo hourly arrays into a list of HourlyForecast
  static List<HourlyForecast> fromJson(Map<String, dynamic> hourly) {
    final times = (hourly['time'] as List?)?.cast<String>() ?? [];
    
    // We use the first model (best_match) for the main displayed values
    final baseModel = ApiConstants.confidenceModels.first;
    
    final temps = (hourly['temperature_2m_$baseModel'] ?? hourly['temperature_2m'] as List?) ?? [];
    final feelsLikes = (hourly['apparent_temperature_$baseModel'] ?? hourly['apparent_temperature'] as List?) ?? [];
    final humidities = (hourly['relative_humidity_2m_$baseModel'] ?? hourly['relative_humidity_2m'] as List?) ?? [];
    final precProbs = (hourly['precipitation_probability_$baseModel'] ?? hourly['precipitation_probability'] as List?) ?? [];
    final precs = (hourly['precipitation_$baseModel'] ?? hourly['precipitation'] as List?) ?? [];
    final codes = (hourly['weather_code_$baseModel'] ?? hourly['weather_code'] as List?) ?? [];
    final winds = (hourly['wind_speed_10m_$baseModel'] ?? hourly['wind_speed_10m'] as List?) ?? [];
    final gusts = (hourly['wind_gusts_10m_$baseModel'] ?? hourly['wind_gusts_10m'] as List?) ?? [];
    final visibilities = (hourly['visibility_$baseModel'] ?? hourly['visibility'] as List?) ?? [];
    final uvIndexes = (hourly['uv_index_$baseModel'] ?? hourly['uv_index'] as List?) ?? [];
    final isDays = (hourly['is_day_$baseModel'] ?? hourly['is_day'] as List?) ?? [];

    final result = <HourlyForecast>[];
    for (var i = 0; i < times.length; i++) {
      // Calculate confidence across models based on precipitation probability std deviation
      final List<double> modelProbs = [];
      for (final model in ApiConstants.confidenceModels) {
        final list = hourly['precipitation_probability_$model'] as List?;
        if (list != null && i < list.length) {
          final val = (list[i] as num?)?.toDouble() ?? 0.0;
          modelProbs.add(val);
        }
      }
      
      ForecastConfidence calculatedConfidence = ForecastConfidence.high;
      if (modelProbs.length > 1) {
        final mean = modelProbs.average;
        final variance = modelProbs.map((p) => pow(p - mean, 2)).average;
        final stdDev = sqrt(variance);
        
        if (stdDev > 25) {
          calculatedConfidence = ForecastConfidence.low;
        } else if (stdDev >= 10) {
          calculatedConfidence = ForecastConfidence.medium;
        } else {
          calculatedConfidence = ForecastConfidence.high;
        }
      }

      result.add(HourlyForecast(
        time: DateTime.tryParse(times[i]) ?? DateTime.now(),
        temperature: (i < temps.length ? temps[i] as num? : null)?.toDouble() ?? 0,
        feelsLike: (i < feelsLikes.length ? feelsLikes[i] as num? : null)?.toDouble() ?? 0,
        humidity: (i < humidities.length ? humidities[i] as num? : null)?.toInt() ?? 0,
        precipitationProbability: (i < precProbs.length ? precProbs[i] as num? : null)?.toInt() ?? 0,
        precipitation: (i < precs.length ? precs[i] as num? : null)?.toDouble() ?? 0,
        weatherCode: (i < codes.length ? codes[i] as num? : null)?.toInt() ?? 0,
        windSpeed: (i < winds.length ? winds[i] as num? : null)?.toDouble() ?? 0,
        windGusts: (i < gusts.length ? gusts[i] as num? : null)?.toDouble() ?? 0,
        visibility: (i < visibilities.length ? visibilities[i] as num? : null)?.toDouble(),
        uvIndex: (i < uvIndexes.length ? uvIndexes[i] as num? : null)?.toDouble(),
        isDay: (i < isDays.length ? isDays[i] as num? : null)?.toInt() == 1,
        confidence: calculatedConfidence,
      ));
    }
    return result;
  }
}
