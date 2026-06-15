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
    final codes = (daily['weather_code'] as List?) ?? [];
    final maxTemps = (daily['temperature_2m_max'] as List?) ?? [];
    final minTemps = (daily['temperature_2m_min'] as List?) ?? [];
    final feelsMaxs = (daily['apparent_temperature_max'] as List?) ?? [];
    final feelsMins = (daily['apparent_temperature_min'] as List?) ?? [];
    final precSums = (daily['precipitation_sum'] as List?) ?? [];
    final precProbs =
        (daily['precipitation_probability_max'] as List?) ?? [];
    final windMaxs = (daily['wind_speed_10m_max'] as List?) ?? [];
    final sunrises = (daily['sunrise'] as List?) ?? [];
    final sunsets = (daily['sunset'] as List?) ?? [];
    final uvMaxs = (daily['uv_index_max'] as List?) ?? [];

    final result = <DailyForecast>[];
    for (var i = 0; i < times.length; i++) {
      result.add(DailyForecast(
        date: DateTime.tryParse(times[i]) ?? DateTime.now(),
        weatherCode:
            (codes.elementAtOrNull(i) as num?)?.toInt() ?? 0,
        tempMax:
            (maxTemps.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        tempMin:
            (minTemps.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        feelsLikeMax:
            (feelsMaxs.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        feelsLikeMin:
            (feelsMins.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        precipitationSum:
            (precSums.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        precipitationProbabilityMax:
            (precProbs.elementAtOrNull(i) as num?)?.toInt() ?? 0,
        windSpeedMax:
            (windMaxs.elementAtOrNull(i) as num?)?.toDouble() ?? 0,
        sunrise: DateTime.tryParse(
            sunrises.elementAtOrNull(i)?.toString() ?? ''),
        sunset: DateTime.tryParse(
            sunsets.elementAtOrNull(i)?.toString() ?? ''),
        uvIndexMax:
            (uvMaxs.elementAtOrNull(i) as num?)?.toDouble(),
      ));
    }
    return result;
  }
}
