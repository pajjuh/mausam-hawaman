/// App-wide constants
class AppConstants {
  AppConstants._();

  // ── App Identity ──
  static const String appName = 'Mausam';
  static const String appTagline = 'Hawaman';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // ── GitHub Repository (for version check) ──
  static const String githubOwner = 'your-github-username';
  static const String githubRepo = 'mausam';

  // ── Weather Refresh ──
  static const Duration weatherRefreshInterval = Duration(minutes: 15);
  static const Duration cacheExpiry = Duration(hours: 1);
  static const int forecastHours = 48;
  static const int forecastDays = 7;

  // ── Location ──
  static const double defaultLatitude = 28.6139; // New Delhi
  static const double defaultLongitude = 77.2090;
  static const int maxSavedLocations = 10;

  // ── Layout ──
  static const double borderRadius = 16.0;
  static const double cardPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double minTapTarget = 48.0;

  // ── Thresholds ──
  static const double highTempThreshold = 40.0; // °C
  static const double lowTempThreshold = 10.0; // °C
  static const int highUvThreshold = 6;
  static const int rainProbabilityAlertThreshold = 70; // %
}
