import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Maps WMO weather codes to human-readable descriptions and icons.
/// Reference: https://open-meteo.com/en/docs#weathervariables
class WeatherUtils {
  WeatherUtils._();

  /// Returns a human-readable weather description from WMO code
  static String getDescription(int code) {
    return switch (code) {
      0 => 'Clear sky',
      1 => 'Mainly clear',
      2 => 'Partly cloudy',
      3 => 'Overcast',
      45 => 'Fog',
      48 => 'Depositing rime fog',
      51 => 'Light drizzle',
      53 => 'Moderate drizzle',
      55 => 'Dense drizzle',
      56 => 'Light freezing drizzle',
      57 => 'Dense freezing drizzle',
      61 => 'Slight rain',
      63 => 'Moderate rain',
      65 => 'Heavy rain',
      66 => 'Light freezing rain',
      67 => 'Heavy freezing rain',
      71 => 'Slight snowfall',
      73 => 'Moderate snowfall',
      75 => 'Heavy snowfall',
      77 => 'Snow grains',
      80 => 'Slight rain showers',
      81 => 'Moderate rain showers',
      82 => 'Violent rain showers',
      85 => 'Slight snow showers',
      86 => 'Heavy snow showers',
      95 => 'Thunderstorm',
      96 => 'Thunderstorm with slight hail',
      99 => 'Thunderstorm with heavy hail',
      _ => 'Unknown',
    };
  }

  /// Returns the appropriate Material icon for a WMO weather code
  static IconData getIcon(int code, {bool isDay = true}) {
    return switch (code) {
      0 => isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
      1 => isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
      2 => isDay
          ? Icons.cloud_queue_rounded
          : Icons.nights_stay_rounded,
      3 => Icons.cloud_rounded,
      45 || 48 => Icons.foggy,
      51 || 53 || 55 => Icons.grain_rounded,
      56 || 57 => Icons.grain_rounded,
      61 || 63 || 80 || 81 => Icons.water_drop_rounded,
      65 || 82 => Icons.thunderstorm_rounded,
      66 || 67 => Icons.ac_unit_rounded,
      71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit_rounded,
      95 || 96 || 99 => Icons.thunderstorm_rounded,
      _ => Icons.help_outline_rounded,
    };
  }

  /// Returns a color representing the weather code
  static Color getColor(int code) {
    return switch (code) {
      0 || 1 => const Color(0xFFFBBF24), // sunny yellow
      2 => const Color(0xFF93C5FD), // light blue
      3 => const Color(0xFF9CA3AF), // gray
      45 || 48 => const Color(0xFFD1D5DB), // fog gray
      51 || 53 || 55 || 56 || 57 => AppColors.rainLight,
      61 || 63 || 80 || 81 => AppColors.rainMedium,
      65 || 66 || 67 || 82 => AppColors.rainHeavy,
      71 || 73 || 75 || 77 || 85 || 86 => const Color(0xFFBFDBFE),
      95 || 96 || 99 => const Color(0xFF7C3AED),
      _ => AppColors.textTertiary,
    };
  }

  /// Returns a color for a temperature value (°C)
  static Color getTemperatureColor(double temp) {
    if (temp >= 42) return AppColors.tempHot;
    if (temp >= 35) return AppColors.tempWarm;
    if (temp >= 25) return AppColors.tempMild;
    if (temp >= 15) return AppColors.tempCool;
    return AppColors.tempCold;
  }

  /// Returns wind direction label from degrees
  static String getWindDirection(double degrees) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
    ];
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  /// Returns UV Index level description
  static String getUvLevel(double uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  /// Returns the path to the corresponding Lottie animation asset
  static String getLottieAsset(int code, {bool isDay = true}) {
    return switch (code) {
      0 => isDay ? 'assets/lottie/clear-day.json' : 'assets/lottie/clear-night.json',
      1 => isDay ? 'assets/lottie/clear-day.json' : 'assets/lottie/clear-night.json',
      2 => isDay ? 'assets/lottie/partly-cloudy-day.json' : 'assets/lottie/partly-cloudy-night.json',
      3 => 'assets/lottie/overcast.json',
      45 || 48 => 'assets/lottie/cloudy.json', // using cloudy as a fallback for fog
      51 || 53 || 55 => 'assets/lottie/drizzle.json',
      56 || 57 => 'assets/lottie/drizzle.json',
      61 || 63 || 65 => 'assets/lottie/rain.json',
      66 || 67 => 'assets/lottie/rain.json',
      71 || 73 || 75 || 77 => 'assets/lottie/snow.json',
      80 || 81 || 82 => 'assets/lottie/rain.json',
      85 || 86 => 'assets/lottie/snow.json',
      95 => isDay ? 'assets/lottie/thunderstorms-day.json' : 'assets/lottie/thunderstorms-night.json',
      96 || 99 => isDay ? 'assets/lottie/thunderstorms-day.json' : 'assets/lottie/thunderstorms-night.json',
      _ => isDay ? 'assets/lottie/clear-day.json' : 'assets/lottie/clear-night.json',
    };
  }

  /// Returns UV Index color
  static Color getUvColor(double uvIndex) {
    if (uvIndex <= 2) return AppColors.success;
    if (uvIndex <= 5) return AppColors.warningLight;
    if (uvIndex <= 7) return AppColors.warning;
    if (uvIndex <= 10) return AppColors.dangerLight;
    return AppColors.danger;
  }

  /// Rain probability label
  static String getRainProbabilityLabel(int probability) {
    if (probability >= 80) return 'Very likely';
    if (probability >= 60) return 'Likely';
    if (probability >= 40) return 'Possible';
    if (probability >= 20) return 'Unlikely';
    return 'No rain expected';
  }

  /// Returns a localized weather description for Vaani TTS.
  /// Falls back to English for unknown codes or locales.
  static String getDescriptionForLocale(int code, String langCode) {
    if (langCode == 'en-IN') return getDescription(code);

    final Map<int, Map<String, String>> translations = {
      0:  {'hi-IN': 'साफ आसमान', 'kn-IN': 'ನಿರಭ್ರ ಆಕಾಶ', 'mr-IN': 'स्वच्छ आकाश'},
      1:  {'hi-IN': 'ज्यादातर साफ', 'kn-IN': 'ಬಹುತೇಕ ನಿರಭ್ರ', 'mr-IN': 'बहुतांश स्वच्छ'},
      2:  {'hi-IN': 'आंशिक बादल', 'kn-IN': 'ಭಾಗಶಃ ಮೋಡ', 'mr-IN': 'अंशतः ढगाळ'},
      3:  {'hi-IN': 'बादल छाए हुए', 'kn-IN': 'ಮೋಡ ಕವಿದಿದೆ', 'mr-IN': 'ढगाळ'},
      45: {'hi-IN': 'कोहरा', 'kn-IN': 'ಮಂಜು', 'mr-IN': 'धुके'},
      48: {'hi-IN': 'घना कोहरा', 'kn-IN': 'ದಟ್ಟ ಮಂಜು', 'mr-IN': 'दाट धुके'},
      51: {'hi-IN': 'हल्की बूंदाबांदी', 'kn-IN': 'ಸಣ್ಣ ತುಂತುರು', 'mr-IN': 'हलकी रिपरिप'},
      53: {'hi-IN': 'बूंदाबांदी', 'kn-IN': 'ತುಂತುರು ಮಳೆ', 'mr-IN': 'रिपरिप'},
      55: {'hi-IN': 'तेज बूंदाबांदी', 'kn-IN': 'ಹೆಚ್ಚಿನ ತುಂತುರು', 'mr-IN': 'जोरदार रिपरिप'},
      56: {'hi-IN': 'हल्की जमती बूंदाबांदी', 'kn-IN': 'ಹಿಮ ತುಂತುರು', 'mr-IN': 'हलकी गोठवणारी रिपरिप'},
      57: {'hi-IN': 'तेज जमती बूंदाबांदी', 'kn-IN': 'ದಟ್ಟ ಹಿಮ ತುಂತುರು', 'mr-IN': 'दाट गोठवणारी रिपरिप'},
      61: {'hi-IN': 'हल्की बारिश', 'kn-IN': 'ಸಣ್ಣ ಮಳೆ', 'mr-IN': 'हलका पाऊस'},
      63: {'hi-IN': 'बारिश', 'kn-IN': 'ಮಳೆ', 'mr-IN': 'पाऊस'},
      65: {'hi-IN': 'भारी बारिश', 'kn-IN': 'ಭಾರೀ ಮಳೆ', 'mr-IN': 'मुसळधार पाऊस'},
      66: {'hi-IN': 'हल्की जमती बारिश', 'kn-IN': 'ಸಣ್ಣ ಹಿಮ ಮಳೆ', 'mr-IN': 'हलका गोठवणारा पाऊस'},
      67: {'hi-IN': 'तेज जमती बारिश', 'kn-IN': 'ಭಾರೀ ಹಿಮ ಮಳೆ', 'mr-IN': 'जोरदार गोठवणारा पाऊस'},
      71: {'hi-IN': 'हल्की बर्फबारी', 'kn-IN': 'ಸಣ್ಣ ಹಿಮಪಾತ', 'mr-IN': 'हलकी हिमवृष्टी'},
      73: {'hi-IN': 'बर्फबारी', 'kn-IN': 'ಹಿಮಪಾತ', 'mr-IN': 'हिमवृष्टी'},
      75: {'hi-IN': 'भारी बर्फबारी', 'kn-IN': 'ಭಾರೀ ಹಿಮಪಾತ', 'mr-IN': 'मुसळधार हिमवृष्टी'},
      77: {'hi-IN': 'बर्फ के कण', 'kn-IN': 'ಹಿಮ ಕಣಗಳು', 'mr-IN': 'हिमकण'},
      80: {'hi-IN': 'हल्की बौछार', 'kn-IN': 'ಸಣ್ಣ ಮಳೆ ಸುರಿತ', 'mr-IN': 'हलक्या सरी'},
      81: {'hi-IN': 'बौछार', 'kn-IN': 'ಮಳೆ ಸುರಿತ', 'mr-IN': 'सरी'},
      82: {'hi-IN': 'तेज बौछार', 'kn-IN': 'ಭಾರೀ ಮಳೆ ಸುರಿತ', 'mr-IN': 'जोरदार सरी'},
      85: {'hi-IN': 'हल्की बर्फ की बौछार', 'kn-IN': 'ಸಣ್ಣ ಹಿಮ ಸುರಿತ', 'mr-IN': 'हलकी हिमसरी'},
      86: {'hi-IN': 'तेज बर्फ की बौछार', 'kn-IN': 'ಭಾರೀ ಹಿಮ ಸುರಿತ', 'mr-IN': 'जोरदार हिमसरी'},
      95: {'hi-IN': 'गरज के साथ तूफान', 'kn-IN': 'ಗುಡುಗು ಸಹಿತ ಮಳೆ', 'mr-IN': 'वादळी पाऊस'},
      96: {'hi-IN': 'ओलों के साथ तूफान', 'kn-IN': 'ಆಲಿಕಲ್ಲು ಸಹಿತ ಗುಡುಗು', 'mr-IN': 'गारांसह वादळ'},
      99: {'hi-IN': 'भारी ओलों के साथ तूफान', 'kn-IN': 'ಭಾರೀ ಆಲಿಕಲ್ಲು ಸಹಿತ ಗುಡುಗು', 'mr-IN': 'मोठ्या गारांसह वादळ'},
    };

    return translations[code]?[langCode] ?? getDescription(code);
  }
}
