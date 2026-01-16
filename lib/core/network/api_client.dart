import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:yb_news/core/constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;
  static const String _corsProxy = 'https://api.allorigins.win/raw?url=';

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kIsWeb ? '' : ApiConstants.gnewsBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['apikey'] = ApiConstants.gnewsApiKey;

          if (kIsWeb) {
            final originalUrl = '${ApiConstants.gnewsBaseUrl}${options.path}';
            final queryString = options.queryParameters.entries
                .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
                .join('&');
            final fullUrl = '$originalUrl?$queryString';
            options.path = '$_corsProxy${Uri.encodeComponent(fullUrl)}';
            options.queryParameters = {};
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
