import 'package:dio/dio.dart';
import 'dio_client.dart';

class RainViewerApiService {
  final Dio _dio;

  RainViewerApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<String?> getLatestRadarPath() async {
    try {
      final response = await _dio.get(
        'https://api.rainviewer.com/public/weather-maps.json',
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final radar = data['radar'] as Map<String, dynamic>?;
        final past = radar?['past'] as List<dynamic>?;

        if (past != null && past.isNotEmpty) {
          final latest = past.last as Map<String, dynamic>;
          return latest['path'] as String?;
        }
      }
      return null;
    } catch (e) {
      return null; // Gracefully fail if radar is unavailable
    }
  }
}
