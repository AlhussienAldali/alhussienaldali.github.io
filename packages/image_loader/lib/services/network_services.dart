import 'package:dio/dio.dart';
import 'package:image_loader/constants.dart';

/// Singleton network services that handles all Api calls
class NetworkService {
  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl, // <-- replace
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
  }

  static final NetworkService _instance = NetworkService._internal();

  /// create one instance to manage api calls
  factory NetworkService() => _instance;

  late final Dio _dio;

  /// Get method to fetch the
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Network error occurred');
    }
  }
}
