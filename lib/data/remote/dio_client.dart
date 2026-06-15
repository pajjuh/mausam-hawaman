import 'package:dio/dio.dart';

/// Configured Dio HTTP client for all API calls
class DioClient {
  static Dio? _instance;

  DioClient._();

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          // Nominatim requires a User-Agent
          'User-Agent': 'Mausam-Hawaman/1.0 (weather-app)',
        },
      ),
    );

    // Add logging in debug mode
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (obj) {
        // Only log in debug builds — print is stripped in release
        assert(() {
          // ignore: avoid_print
          print('[DIO] $obj');
          return true;
        }());
      },
    ));

    return dio;
  }
}
