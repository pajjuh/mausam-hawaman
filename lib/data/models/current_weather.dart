/// Current weather snapshot from Open-Meteo
class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int weatherCode;
  final double windSpeed;
  final double windDirection;
  final double? pressure;
  final double? visibility;
  final bool isDay;
  final DateTime time;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    this.pressure,
    this.visibility,
    required this.isDay,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0,
      feelsLike: (json['apparent_temperature'] as num?)?.toDouble() ?? 0,
      humidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0,
      windDirection: (json['wind_direction_10m'] as num?)?.toDouble() ?? 0,
      pressure: (json['surface_pressure'] as num?)?.toDouble(),
      visibility: (json['visibility'] as num?)?.toDouble(),
      isDay: (json['is_day'] as num?)?.toInt() == 1,
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
