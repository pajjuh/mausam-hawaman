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
  });

  /// Parse the Open-Meteo hourly arrays into a list of HourlyForecast
  static List<HourlyForecast> fromJson(Map<String, dynamic> hourly) {
    final times = (hourly['time'] as List?)?.cast<String>() ?? [];
    final temps = (hourly['temperature_2m'] as List?) ?? [];
    final feelsLikes = (hourly['apparent_temperature'] as List?) ?? [];
    final humidities = (hourly['relative_humidity_2m'] as List?) ?? [];
    final precProbs =
        (hourly['precipitation_probability'] as List?) ?? [];
    final precs = (hourly['precipitation'] as List?) ?? [];
    final codes = (hourly['weather_code'] as List?) ?? [];
    final winds = (hourly['wind_speed_10m'] as List?) ?? [];
    final gusts = (hourly['wind_gusts_10m'] as List?) ?? [];
    final visibilities = (hourly['visibility'] as List?) ?? [];
    final uvIndexes = (hourly['uv_index'] as List?) ?? [];
    final isDays = (hourly['is_day'] as List?) ?? [];

    final result = <HourlyForecast>[];
    for (var i = 0; i < times.length; i++) {
      result.add(HourlyForecast(
        time: DateTime.tryParse(times[i]) ?? DateTime.now(),
        temperature: (temps.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        feelsLike:
            (feelsLikes.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        humidity:
            (humidities.elementAtOrNull(i) as num?)?.toInt() ?? 0,
        precipitationProbability:
            (precProbs.elementAtOrNull(i) as num?)?.toInt() ?? 0,
        precipitation:
            (precs.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        weatherCode:
            (codes.elementAtOrNull(i) as num?)?.toInt() ?? 0,
        windSpeed:
            (winds.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        windGusts:
            (gusts.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        visibility:
            (visibilities.elementAtOrNull(i) as num?)?.toDouble(),
        uvIndex: (uvIndexes.elementAtOrNull(i) as num?)?.toDouble(),
        isDay: (isDays.elementAtOrNull(i) as num?)?.toInt() == 1,
      ));
    }
    return result;
  }
}
