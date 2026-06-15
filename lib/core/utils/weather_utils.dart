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
}
