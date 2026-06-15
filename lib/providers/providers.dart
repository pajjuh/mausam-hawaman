import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';
import '../data/remote/dio_client.dart';
import '../data/remote/geocoding_service.dart';
import '../data/remote/weather_api_service.dart';
import '../data/remote/github_api_service.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/weather_repository.dart';
import '../data/models/location_data.dart';
import '../data/models/weather_response.dart';
import '../data/models/aqi_data.dart';
import '../data/remote/aqi_api_service.dart';
import '../data/remote/rainviewer_api_service.dart';
import '../data/repositories/aqi_repository.dart';
import '../core/constants/app_constants.dart';

// ═══════════════════════════════════════════════════════
//  Singletons — Database & Services
// ═══════════════════════════════════════════════════════

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  return WeatherApiService(dio: DioClient.instance);
});

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingService(dio: DioClient.instance);
});

final githubApiServiceProvider = Provider<GitHubApiService>((ref) {
  return GitHubApiService(dio: DioClient.instance);
});

final aqiApiServiceProvider = Provider<AqiApiService>((ref) {
  return AqiApiService(dio: DioClient.instance);
});

final rainViewerApiServiceProvider = Provider<RainViewerApiService>((ref) {
  return RainViewerApiService(dio: DioClient.instance);
});

// ═══════════════════════════════════════════════════════
//  Repositories
// ═══════════════════════════════════════════════════════

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(
    apiService: ref.watch(weatherApiServiceProvider),
    db: ref.watch(databaseProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(
    geocodingService: ref.watch(geocodingServiceProvider),
    db: ref.watch(databaseProvider),
  );
});

final aqiRepositoryProvider = Provider<AqiRepository>((ref) {
  return AqiRepository(
    ref.watch(databaseProvider),
    ref.watch(aqiApiServiceProvider),
  );
});

// ═══════════════════════════════════════════════════════
//  Location State
// ═══════════════════════════════════════════════════════

/// The currently active location
final currentLocationProvider =
    StateNotifierProvider<CurrentLocationNotifier, AsyncValue<LocationData>>(
        (ref) {
  return CurrentLocationNotifier(ref);
});

class CurrentLocationNotifier extends StateNotifier<AsyncValue<LocationData>> {
  final Ref _ref;

  CurrentLocationNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = _ref.read(locationRepositoryProvider);

      // Try to load saved default location first
      final saved = await repo.getDefaultLocation();
      if (saved != null) {
        state = AsyncValue.data(saved);
        return;
      }

      // No saved location — detect via GPS
      await detectLocation();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Detect current location via GPS
  Future<void> detectLocation() async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(locationRepositoryProvider);
      final location = await repo.detectCurrentLocation();
      final saved = await repo.saveLocation(location, setAsDefault: true);
      state = AsyncValue.data(saved);
    } catch (e) {
      // Fall back to Delhi if GPS fails
      state = AsyncValue.data(const LocationData(
        name: 'New Delhi',
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
        district: 'Central Delhi',
        state: 'Delhi',
      ));
    }
  }

  /// Set a specific location as active
  Future<void> setLocation(LocationData location) async {
    state = AsyncValue.data(location);
    if (location.id != null) {
      final repo = _ref.read(locationRepositoryProvider);
      await repo.setDefault(location.id!);
    }
    // Invalidate weather data so it refetches
    _ref.invalidate(weatherProvider);
  }

  /// Set location from search result (save and activate)
  Future<void> selectSearchResult(LocationData location) async {
    try {
      final repo = _ref.read(locationRepositoryProvider);
      final saved = await repo.saveLocation(location, setAsDefault: true);
      state = AsyncValue.data(saved);
      _ref.invalidate(weatherProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// All saved locations
final savedLocationsProvider = FutureProvider<List<LocationData>>((ref) async {
  final repo = ref.watch(locationRepositoryProvider);
  return repo.getSavedLocations();
});

// ═══════════════════════════════════════════════════════
//  Weather State
// ═══════════════════════════════════════════════════════

/// Weather data for the current location
final weatherProvider = FutureProvider<WeatherResponse>((ref) async {
  final locationAsync = ref.watch(currentLocationProvider);

  final location = locationAsync.valueOrNull;
  if (location == null) {
    throw Exception('No location available');
  }

  final repo = ref.watch(weatherRepositoryProvider);
  return repo.getWeather(
    locationId: location.id ?? 0,
    latitude: location.latitude,
    longitude: location.longitude,
  );
});

/// Force refresh weather data
final weatherRefreshProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final locationAsync = ref.read(currentLocationProvider);
    final location = locationAsync.valueOrNull;
    if (location == null) return;

    final repo = ref.read(weatherRepositoryProvider);
    await repo.getWeather(
      locationId: location.id ?? 0,
      latitude: location.latitude,
      longitude: location.longitude,
      forceRefresh: true,
    );
    ref.invalidate(weatherProvider);
  };
});

// ═══════════════════════════════════════════════════════
//  AQI State
// ═══════════════════════════════════════════════════════

/// Air Quality data for the current location
final aqiProvider = FutureProvider<AqiData>((ref) async {
  final locationAsync = ref.watch(currentLocationProvider);
  
  final location = locationAsync.valueOrNull;
  if (location == null) {
    throw Exception('No location available');
  }

  final repo = ref.watch(aqiRepositoryProvider);
  return repo.getAqi(location);
});

// ═══════════════════════════════════════════════════════
//  Radar State
// ═══════════════════════════════════════════════════════

final radarPathProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(rainViewerApiServiceProvider);
  return service.getLatestRadarPath();
});

// ═══════════════════════════════════════════════════════
//  Version Check
// ═══════════════════════════════════════════════════════

/// Check GitHub for the latest release
final versionCheckProvider = FutureProvider<GitHubRelease?>((ref) async {
  final service = ref.watch(githubApiServiceProvider);
  return service.getLatestRelease();
});

/// Whether an update is available
final updateAvailableProvider = Provider<bool>((ref) {
  final releaseAsync = ref.watch(versionCheckProvider);
  final release = releaseAsync.valueOrNull;
  if (release == null) return false;

  return GitHubApiService.isUpdateAvailable(
    AppConstants.appVersion,
    release.tagName,
  );
});

// ═══════════════════════════════════════════════════════
//  Location Search
// ═══════════════════════════════════════════════════════

/// Search query text
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search results from Nominatim
final searchResultsProvider =
    FutureProvider<List<LocationData>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  final repo = ref.watch(locationRepositoryProvider);
  return repo.searchLocations(query);
});
