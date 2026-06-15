import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/location_data.dart';
import 'dio_client.dart';

/// Service for geocoding via Nominatim (OpenStreetMap)
class GeocodingService {
  final Dio _dio;

  GeocodingService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  /// Reverse geocode: coordinates → location name
  Future<LocationData> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.reverseGeocode,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'addressdetails': 1,
          'accept-language': 'en',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return LocationData.fromNominatim(
            response.data as Map<String, dynamic>);
      }

      throw Exception('Reverse geocoding failed: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
          'Geocoding error: ${e.message ?? 'Network error'}');
    }
  }

  /// Search for locations by name, PIN code, or village name
  Future<List<LocationData>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.searchGeocode,
        queryParameters: {
          'q': '$query, India',
          'format': 'json',
          'addressdetails': 1,
          'limit': 8,
          'accept-language': 'en',
          'countrycodes': 'in',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final results = response.data as List;
        return results
            .map((e) =>
                LocationData.fromSearchResult(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }
}
