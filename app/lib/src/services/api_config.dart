import 'package:dio/dio.dart';

class ApiConfig {
  // Update this URL based on your testing environment
  // For Android Emulator (recommended for testing)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Alternative configurations:
  // For iOS Simulator: 'http://localhost:8000/api'
  // For Web development: 'http://localhost:8000/api'
  // For physical device: 'http://YOUR_COMPUTER_IP:8000/api'

  // Dio instance with advanced configuration
  static late Dio _dio;

  static Dio get dio {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30), // LLM calls can be slow
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print('🌐 API: $obj'), // Custom log prefix
      ),
    );

    // Add retry interceptor for failed requests
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    return _dio;
  }

  // Legacy headers for backward compatibility
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

// Custom retry interceptor for robust API calls
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retryAttempt = extra['retryAttempt'] ?? 0;

    if (retryAttempt < retries && _shouldRetry(err)) {
      extra['retryAttempt'] = retryAttempt + 1;

      print('🔄 Retrying API call (attempt ${retryAttempt + 1}/$retries)');

      // Wait before retry
      if (retryAttempt < retryDelays.length) {
        await Future.delayed(retryDelays[retryAttempt]);
      } else {
        await Future.delayed(retryDelays.last);
      }

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue to next retry or fail
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
