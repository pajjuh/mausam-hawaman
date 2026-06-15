import 'package:drift/drift.dart';
import '../local/database.dart';
import '../models/aqi_data.dart';
import '../models/location_data.dart';
import '../remote/aqi_api_service.dart';

class AqiRepository {
  final AppDatabase _db;
  final AqiApiService _api;

  AqiRepository(this._db, this._api);

  Future<AqiData> getAqi(LocationData location, {bool forceRefresh = false}) async {
    final locationId = location.id;

    if (!forceRefresh && locationId != null) {
      final cached = await _db.getLatestAqi(locationId);
      if (cached != null) {
        final age = DateTime.now().difference(cached.fetchedAt);
        if (age.inMinutes < 30) {
          return AqiData(
            aqi: cached.aqi,
            pm10: cached.pm10,
            pm25: cached.pm25,
            uvIndex: cached.uvIndex,
            time: cached.fetchedAt,
          );
        }
      }
    }

    // Fetch from API
    final freshData = await _api.getAqi(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    // Save to Cache
    if (locationId != null) {
      await _db.insertAqiRecord(
        AqiRecordsCompanion(
          locationId: Value(locationId),
          fetchedAt: Value(DateTime.now()),
          aqi: Value(freshData.aqi),
          pm25: Value(freshData.pm25),
          pm10: Value(freshData.pm10),
          uvIndex: Value(freshData.uvIndex),
        ),
      );
      // Clean up old records
      await _db.deleteOldAqiRecords(const Duration(days: 2));
    }

    return freshData;
  }
}
