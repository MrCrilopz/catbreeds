import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createApiClient({required String baseUrl, required String apiKey}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  dio.interceptors.add(_ApiKeyInterceptor(apiKey));
  return dio;
}

final class _ApiKeyInterceptor extends Interceptor {
  _ApiKeyInterceptor(this._apiKey);

  final String _apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = _apiKey;
    if (kDebugMode) {
      debugPrint('${options.method} ${options.uri.path}');
    }
    handler.next(options);
  }
}
