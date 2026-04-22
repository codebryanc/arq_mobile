import 'package:dio/dio.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  // [Constructor]
  const ErrorInterceptor({this.defaultServerError = ''});

  // [Properties]
  final String defaultServerError;

  // [Methods]
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(err.copyWith(error: const NetworkException()));

      case DioExceptionType.badResponse:
        handler.reject(
          err.copyWith(
            error: ServerException(
              message: _extractMessage(err.response),
              statusCode: err.response?.statusCode,
            ),
          ),
        );

      default:
        handler.next(err);
    }
  }

  String _extractMessage(Response? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      return data['status_message'] as String? ?? defaultServerError;
    }
    return defaultServerError;
  }
}
