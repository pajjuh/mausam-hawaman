import '../../core/utils/weather_utils.dart';
import '../../data/models/current_weather.dart';
import '../../data/models/hourly_forecast.dart';
import '../../data/models/location_data.dart';

/// Builds the voice script for Vaani TTS in the selected language.
/// Uses only already-fetched Open-Meteo data — fully offline.
class VaaniScriptBuilder {
  VaaniScriptBuilder._();

  /// Build the complete voice script for the given language and weather data.
  static String buildScript({
    required String langCode,
    required LocationData location,
    required CurrentWeather current,
    required List<HourlyForecast> hourly,
  }) {
    final locationName = location.name;
    final temp = current.temperature.round();
    final feelsLike = current.feelsLike.round();
    final condition = WeatherUtils.getDescriptionForLocale(
      current.weatherCode,
      langCode,
    );
    final humidity = current.humidity;
    final windSpeed = current.windSpeed.round();
    final rainProb = _getCurrentHourRainProbability(hourly);

    return switch (langCode) {
      'hi-IN' => _buildHindi(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb),
      'kn-IN' => _buildKannada(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb),
      'mr-IN' => _buildMarathi(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb),
      _ => _buildEnglish(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb),
    };
  }

  /// Get rain probability for the current hour from hourly data
  static int _getCurrentHourRainProbability(List<HourlyForecast> hourly) {
    if (hourly.isEmpty) return 0;

    final now = DateTime.now();
    // Find the hourly entry closest to the current time
    HourlyForecast closest = hourly.first;
    int minDiff = (now.difference(closest.time).inMinutes).abs();

    for (final h in hourly) {
      final diff = (now.difference(h.time).inMinutes).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = h;
      }
    }

    return closest.precipitationProbability;
  }

  static String _buildEnglish(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb,
  ) {
    return 'Hello! In $location today, the temperature is $temp degrees Celsius, '
        'feeling like $feelsLike degrees. '
        'The sky is $condition. '
        'Humidity is $humidity percent. '
        'Wind speed is $windSpeed kilometres per hour. '
        'Rain probability for today is $rainProb percent. '
        'Have a good day!';
  }

  static String _buildHindi(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb,
  ) {
    return 'Namaste! Aaj $location mein temperature $temp degree Celsius hai, '
        'lekin $feelsLike degree jaisa lag raha hai. '
        'Aasman $condition hai. '
        'Aardrata $humidity percent hai. '
        'Hawa ki gati $windSpeed kilometre pratighanta hai. '
        'Aaj barish ki sambhavna $rainProb percent hai. '
        'Dhanyavaad!';
  }

  static String _buildKannada(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb,
  ) {
    return 'Namaskara! Eedu $location nalli ivattu $temp degree Celsius temperature ide, '
        'aadu $feelsLike degree tara anistide. '
        'Aakasha $condition agide. '
        'Taniyate $humidity percent ide. '
        'Gaalige vega $windSpeed kilometre pratighantege ide. '
        'Ivattu male aguvudara sambhavana $rainProb percent. '
        'Dhanyavaadagalu!';
  }

  static String _buildMarathi(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb,
  ) {
    return 'Namaskar! Aaj $location madhe temperature $temp degree Celsius ahe, '
        'pan $feelsLike degree sarkhe vatate. '
        'Aakash $condition ahe. '
        'Aardrata $humidity percent ahe. '
        'Vaaryachi gati $windSpeed kilometre pratitasaas ahe. '
        'Aaj paavsachi shakyta $rainProb percent ahe. '
        'Dhanyavaad!';
  }
}
