import '../../core/utils/weather_utils.dart';
import '../../core/utils/unit_converter.dart';
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
    required String tempUnit,
    required String windUnit,
  }) {
    final locationName = location.name;
    final temp = UnitConverter.convertTemp(current.temperature, tempUnit);
    final feelsLike = UnitConverter.convertTemp(current.feelsLike, tempUnit);
    final condition = WeatherUtils.getDescriptionForLocale(
      current.weatherCode,
      langCode,
    );
    final humidity = current.humidity.round();
    final windSpeed = UnitConverter.convertWindSpeed(current.windSpeed, windUnit);
    final rainProb = _getCurrentHourRainProbability(hourly);

    return switch (langCode) {
      'hi-IN' => _buildHindi(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb, tempUnit, windUnit),
      'kn-IN' => _buildKannada(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb, tempUnit, windUnit),
      'mr-IN' => _buildMarathi(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb, tempUnit, windUnit),
      _ => _buildEnglish(locationName, temp, feelsLike, condition, humidity, windSpeed, rainProb, tempUnit, windUnit),
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
    int humidity, int windSpeed, int rainProb, String tempUnit, String windUnit,
  ) {
    final tUnitStr = tempUnit == 'F' ? 'Fahrenheit' : 'Celsius';
    final wUnitStr = windUnit == 'ms' ? 'meters per second' : 'kilometres per hour';
    
    return 'Hello! In $location today, the temperature is $temp degrees $tUnitStr, '
        'feeling like $feelsLike degrees. '
        'The sky is $condition. '
        'Humidity is $humidity percent. '
        'Wind speed is $windSpeed $wUnitStr. '
        'Rain probability for today is $rainProb percent. '
        'Have a good day!';
  }

  static String _buildHindi(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb, String tempUnit, String windUnit,
  ) {
    final tUnitStr = tempUnit == 'F' ? 'फ़ारेनहाइट' : 'सेल्सियस';
    final wUnitStr = windUnit == 'ms' ? 'मीटर प्रति सेकंड' : 'किलोमीटर प्रति घंटा';

    return 'नमस्ते! आज $location में तापमान $temp डिग्री $tUnitStr है, '
        'लेकिन यह $feelsLike डिग्री जैसा लग रहा है। '
        'आसमान $condition है। '
        'आर्द्रता $humidity प्रतिशत है। '
        'हवा की गति $windSpeed $wUnitStr है। '
        'आज बारिश की संभावना $rainProb प्रतिशत है। '
        'धन्यवाद!';
  }

  static String _buildKannada(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb, String tempUnit, String windUnit,
  ) {
    final tUnitStr = tempUnit == 'F' ? 'ಫ್ಯಾರನ್‌ಹೀಟ್' : 'ಸೆಲ್ಸಿಯಸ್';
    final wUnitStr = windUnit == 'ms' ? 'ಸೆಕೆಂಡಿಗೆ ಮೀಟರ್' : 'ಗಂಟೆಗೆ ಕಿಲೋಮೀಟರ್';

    return 'ನಮಸ್ಕಾರ! ಇಂದು $location ನಲ್ಲಿ ತಾಪಮಾನ $temp ಡಿಗ್ರಿ $tUnitStr ಇದೆ, '
        'ಆದರೆ $feelsLike ಡಿಗ್ರಿ ಯಂತೆ ಅನಿಸುತ್ತಿದೆ. '
        'ಆಕಾಶ $condition ಆಗಿದೆ. '
        'ತೇವಾಂಶ ಶೇಕಡಾ $humidity ರಷ್ಟಿದೆ. '
        'ಗಾಳಿಯ ವೇಗ $wUnitStr $windSpeed ಇದೆ. '
        'ಇಂದು ಮಳೆಯಾಗುವ ಸಾಧ್ಯತೆ ಶೇಕಡಾ $rainProb ರಷ್ಟಿದೆ. '
        'ಧನ್ಯವಾದಗಳು!';
  }

  static String _buildMarathi(
    String location, int temp, int feelsLike, String condition,
    int humidity, int windSpeed, int rainProb, String tempUnit, String windUnit,
  ) {
    final tUnitStr = tempUnit == 'F' ? 'फॅरेनहाइट' : 'सेल्सियस';
    final wUnitStr = windUnit == 'ms' ? 'मीटर प्रति सेकंद' : 'किलोमीटर प्रतितास';

    return 'नमस्कार! आज $location मध्ये तापमान $temp डिग्री $tUnitStr आहे, '
        'पण $feelsLike डिग्री सारखे वाटत आहे. '
        'आकाश $condition आहे. '
        'आर्द्रता $humidity टक्के आहे. '
        'वाऱ्याची गती $windSpeed $wUnitStr आहे. '
        'आज पावसाची शक्यता $rainProb टक्के आहे. '
        'धन्यवाद!';
  }
}
