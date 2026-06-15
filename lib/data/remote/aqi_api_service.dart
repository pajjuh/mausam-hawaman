import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/aqi_data.dart';
import 'dio_client.dart';

class AqiApiService {
  final Dio _dio;

  AqiApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<AqiData> getAqi({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.airQualityEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current': 'us_aqi,pm10,pm2_5,uv_index',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return AqiData.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch AQI: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('AQI API error: ${e.message ?? 'Network error'}');
    }
  }
}
