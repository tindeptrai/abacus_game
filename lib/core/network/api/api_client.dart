import 'package:dio/dio.dart';
import '../network.dart';

class ApiClient {
  static const int timeoutDuration = 30000; // 30 seconds

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstance.baseUrl,
        connectTimeout: const Duration(milliseconds: timeoutDuration),
        receiveTimeout: const Duration(milliseconds: timeoutDuration),
        sendTimeout: const Duration(milliseconds: timeoutDuration),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.addAll([
        AuthInterceptor(),
        LoggingInterceptor(),
        ErrorInterceptor(),
      ]);
  }

  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioError(e);
    }
  }

  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDioError(e);
    }
  }

  T _handleResponse<T>(Response response) {
    if (response.data is! Map<String, dynamic>) {
      throw const NetworkExceptions.invalidResponse();
    }

    final baseResponse =
        BaseResponse.fromJson(response.data as Map<String, dynamic>, (json) => json);

    if (!baseResponse.success) {
      throw NetworkExceptions.serverError(
          baseResponse.message ?? 'Unknown error occurred');
    }

    return baseResponse.data as T;
  }
}
