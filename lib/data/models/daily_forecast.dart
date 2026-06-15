import 'package:collection/collection.dart';
import '../../core/constants/api_constants.dart';

/// Single day of forecast data from Open-Meteo
class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final double feelsLikeMax;
  final double feelsLikeMin;
  final double precipitationSum;
  final int precipitationProbabilityMax;
  final double windSpeedMax;
  final DateTime? sunrise;
  final DateTime? sunset;
  final double? uvIndexMax;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.feelsLikeMax,
    required this.feelsLikeMin,
    required this.precipitationSum,
    required this.precipitationProbabilityMax,
    required this.windSpeedMax,
    this.sunrise,
    this.sunset,
    this.uvIndexMax,
  });

  /// Parse the Open-Meteo daily arrays into a list of DailyForecast
  static List<DailyForecast> fromJson(Map<String, dynamic> daily) {
    final times = (daily['time'] as List?)?.cast<String>() ?? [];
    
    final baseModel = ApiConstants.confidenceModels.first;

    final codes = (daily['weather_code_$baseModel'] ?? daily['weather_code'] as List?) ?? [];
    final maxTemps = (daily['temperature_2m_max_$baseModel'] ?? daily['temperature_2m_max'] as List?) ?? [];
    final minTemps = (daily['temperature_2m_min_$baseModel'] ?? daily['temperature_2m_min'] as List?) ?? [];
    final feelsMaxs = (daily['apparent_temperature_max_$baseModel'] ?? daily['apparent_temperature_max'] as List?) ?? [];
    final feelsMins = (daily['apparent_temperature_min_$baseModel'] ?? daily['apparent_temperature_min'] as List?) ?? [];
    final precSums = (daily['precipitation_sum_$baseModel'] ?? daily['precipitation_sum'] as List?) ?? [];
    final precProbs = (daily['precipitation_probability_max_$baseModel'] ?? daily['precipitation_probability_max'] as List?) ?? [];
    final windMaxs = (daily['wind_speed_10m_max_$baseModel'] ?? daily['wind_speed_10m_max'] as List?) ?? [];
    final sunrises = (daily['sunrise_$baseModel'] ?? daily['sunrise'] as List?) ?? [];
    final sunsets = (daily['sunset_$baseModel'] ?? daily['sunset'] as List?) ?? [];
    final uvMaxs = (daily['uv_index_max_$baseModel'] ?? daily['uv_index_max'] as List?) ?? [];

    final result = <DailyForecast>[];
    for (var i = 0; i < times.length; i++) {
      result.add(DailyForecast(
        date: DateTime.tryParse(times[i]) ?? DateTime.now(),
        weatherCode:
            (i < codes.length ? codes[i] as num? : null)?.toInt() ?? 0,
        tempMax:
            (i < maxTemps.length ? maxTemps[i] as num? : null)?.toDouble() ?? 0,
        tempMin:
            (i < minTemps.length ? minTemps[i] as num? : null)?.toDouble() ?? 0,
        feelsLikeMax:
            (i < feelsMaxs.length ? feelsMaxs[i] as num? : null)?.toDouble() ?? 0,
        feelsLikeMin:
            (i < feelsMins.length ? feelsMins[i] as num? : null)?.toDouble() ?? 0,
        precipitationSum:
            (i < precSums.length ? precSums[i] as num? : null)?.toDouble() ?? 0,
        precipitationProbabilityMax:
            (i < precProbs.length ? precProbs[i] as num? : null)?.toInt() ?? 0,
        windSpeedMax:
            (i < windMaxs.length ? windMaxs[i] as num? : null)?.toDouble() ?? 0,
        sunrise: DateTime.tryParse(
            (i < sunrises.length ? sunrises[i] : null)?.toString() ?? ''),
        sunset: DateTime.tryParse(
            (i < sunsets.length ? sunsets[i] : null)?.toString() ?? ''),
        uvIndexMax:
            (i < uvMaxs.length ? uvMaxs[i] as num? : null)?.toDouble(),
      ));
    }
    return result;
  }
}
