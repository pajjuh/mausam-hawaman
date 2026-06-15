import 'package:drift/drift.dart';
import 'package:geolocator/geolocator.dart';

import '../local/database.dart';
import '../models/location_data.dart';
import '../remote/geocoding_service.dart';

/// Repository for location detection, search, and persistence
class LocationRepository {
  final GeocodingService _geocodingService;
  final AppDatabase _db;

  LocationRepository({
    required GeocodingService geocodingService,
    required AppDatabase db,
  })  : _geocodingService = geocodingService,
        _db = db;

  /// Detect current location via GPS + reverse geocode
  Future<LocationData> detectCurrentLocation() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    // Check and request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permission permanently denied. Please enable in Settings.');
    }

    // Get position
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );

    // Reverse geocode
    final location = await _geocodingService.reverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return location;
  }

  /// Search for locations by query string
  Future<List<LocationData>> searchLocations(String query) {
    return _geocodingService.searchLocations(query);
  }

  /// Save a location to the database and return its ID
  Future<LocationData> saveLocation(LocationData location,
      {bool setAsDefault = false}) async {
    final id = await _db.insertLocation(LocationsCompanion(
      name: Value(location.name),
      lat: Value(location.latitude),
      lng: Value(location.longitude),
      isDefault: Value(setAsDefault),
      district: Value(location.district),
      state: Value(location.state),
    ));

    if (setAsDefault) {
      await _db.setDefaultLocation(id);
    }

    return location.copyWith(id: id, isDefault: setAsDefault);
  }

  /// Get all saved locations
  Future<List<LocationData>> getSavedLocations() async {
    final rows = await _db.getAllLocations();
    return rows
        .map((r) => LocationData(
              id: r.id,
              name: r.name,
              latitude: r.lat,
              longitude: r.lng,
              isDefault: r.isDefault,
              district: r.district,
              state: r.state,
            ))
        .toList();
  }

  /// Get the default location
  Future<LocationData?> getDefaultLocation() async {
    final row = await _db.getDefaultLocation();
    if (row == null) return null;

    return LocationData(
      id: row.id,
      name: row.name,
      latitude: row.lat,
      longitude: row.lng,
      isDefault: true,
      district: row.district,
      state: row.state,
    );
  }

  /// Delete a saved location
  Future<void> deleteLocation(int id) => _db.deleteLocation(id);

  /// Set a location as the default
  Future<void> setDefault(int id) => _db.setDefaultLocation(id);
}
