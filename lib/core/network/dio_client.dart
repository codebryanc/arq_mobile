import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:arq_mobile/core/network/dio_error_interceptor.dart';
import 'package:arq_mobile/core/network/dio_headers.dart';

class DioClient {
  // [Constructor]
  DioClient._();

  // [Methods]
  static Dio create({required String defaultServerError}) {
    final dio = Dio(DioHeaders.baseOptions);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    dio.interceptors.add(
      ErrorInterceptor(defaultServerError: defaultServerError),
    );

    return dio;
  }
}
