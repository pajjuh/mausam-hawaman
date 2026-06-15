/// API endpoints — all free, no keys required
class ApiConstants {
  ApiConstants._();

  // ── Open-Meteo Weather API ──
  static const String openMeteoBase = 'https://api.open-meteo.com/v1';
  static const String weatherEndpoint = '$openMeteoBase/forecast';

  /// Current weather fields
  static const List<String> currentParams = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'weather_code',
    'wind_speed_10m',
    'wind_direction_10m',
    'surface_pressure',
    'visibility',
    'is_day',
  ];

  /// Hourly forecast fields
  static const List<String> hourlyParams = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'precipitation_probability',
    'precipitation',
    'weather_code',
    'wind_speed_10m',
    'wind_gusts_10m',
    'visibility',
    'uv_index',
    'is_day',
  ];

  /// Daily forecast fields
  static const List<String> dailyParams = [
    'weather_code',
    'temperature_2m_max',
    'temperature_2m_min',
    'apparent_temperature_max',
    'apparent_temperature_min',
    'precipitation_sum',
    'precipitation_probability_max',
    'wind_speed_10m_max',
    'sunrise',
    'sunset',
    'uv_index_max',
  ];

  // ── Nominatim Geocoding API ──
  static const String nominatimBase = 'https://nominatim.openstreetmap.org';
  static const String reverseGeocode = '$nominatimBase/reverse';
  static const String searchGeocode = '$nominatimBase/search';

  // ── GitHub Releases API ──
  static const String githubApiBase = 'https://api.github.com';

  static String githubLatestRelease(String owner, String repo) =>
      '$githubApiBase/repos/$owner/$repo/releases/latest';

  // ── Open-Meteo Air Quality API (Phase 2) ──
  static const String airQualityEndpoint =
      'https://air-quality-api.open-meteo.com/v1/air-quality';
      
  /// Models for Confidence Engine (Phase 2)
  static const List<String> confidenceModels = [
    'best_match',
    'gfs_seamless',
    'icon_seamless',
    'ecmwf_ifs04'
  ];
}
