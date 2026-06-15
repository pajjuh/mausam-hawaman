import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ── Table Definitions ──

/// Saved locations (GPS-detected or manually searched)
class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get district => text().nullable()();
  TextColumn get state => text().nullable()();
}

/// Cached weather forecast data
class WeatherForecasts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get locationId =>
      integer().references(Locations, #id)();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get model => text().withDefault(const Constant('open_meteo'))();
  TextColumn get hourlyJson => text()();
  TextColumn get dailyJson => text()();
}

/// Cached air quality records (Phase 2)
class AqiRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get locationId =>
      integer().references(Locations, #id)();
  DateTimeColumn get fetchedAt => dateTime()();
  IntColumn get aqi => integer()();
  RealColumn get pm25 => real()();
  RealColumn get pm10 => real()();
  RealColumn get uvIndex => real()();
}

/// Farming mode logs (Phase 3)
class FarmingLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get locationId =>
      integer().references(Locations, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get sprayWindowsJson => text()();
  RealColumn get soilMoisture => real()();
  TextColumn get crop => text().nullable()();
}

// ── Database Class ──

@DriftDatabase(tables: [Locations, WeatherForecasts, AqiRecords, FarmingLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Location Queries ──

  Future<List<Location>> getAllLocations() => select(locations).get();

  Stream<List<Location>> watchAllLocations() => select(locations).watch();

  Future<Location?> getDefaultLocation() =>
      (select(locations)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  Future<int> insertLocation(LocationsCompanion entry) =>
      into(locations).insert(entry);

  Future<bool> updateLocation(Location entry) =>
      update(locations).replace(entry);

  Future<int> deleteLocation(int id) =>
      (delete(locations)..where((t) => t.id.equals(id))).go();

  /// Set a location as default (and unset all others)
  Future<void> setDefaultLocation(int locationId) async {
    await transaction(() async {
      // Unset all defaults
      await (update(locations)
            ..where((t) => t.isDefault.equals(true)))
          .write(const LocationsCompanion(isDefault: Value(false)));
      // Set the new default
      await (update(locations)
            ..where((t) => t.id.equals(locationId)))
          .write(const LocationsCompanion(isDefault: Value(true)));
    });
  }

  // ── Weather Forecast Queries ──

  Future<WeatherForecast?> getLatestForecast(int locationId) =>
      (select(weatherForecasts)
            ..where((t) => t.locationId.equals(locationId))
            ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertForecast(WeatherForecastsCompanion entry) =>
      into(weatherForecasts).insert(entry);

  /// Delete forecasts older than [expiry]
  Future<int> deleteOldForecasts(Duration expiry) {
    final cutoff = DateTime.now().subtract(expiry);
    return (delete(weatherForecasts)
          ..where((t) => t.fetchedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  // ── AQI Records Queries ──

  Future<AqiRecord?> getLatestAqi(int locationId) =>
      (select(aqiRecords)
            ..where((t) => t.locationId.equals(locationId))
            ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertAqiRecord(AqiRecordsCompanion entry) =>
      into(aqiRecords).insert(entry);

  Future<int> deleteOldAqiRecords(Duration expiry) {
    final cutoff = DateTime.now().subtract(expiry);
    return (delete(aqiRecords)
          ..where((t) => t.fetchedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}

// ── Connection Setup ──

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'mausam.db'));
    return NativeDatabase.createInBackground(file);
  });
}
