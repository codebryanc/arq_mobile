import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/network/dio_error_interceptor.dart';

class _MockHandler extends Mock implements ErrorInterceptorHandler {}

// Test constants
const _kDefaultError = 'Server error';
const _kStatusMessage = 'Resource not found';
const _kStatusCode = 404;
const _kPath = '/test';

DioException _makeErr(DioExceptionType type, {Response<dynamic>? response}) =>
    DioException(
      requestOptions: RequestOptions(path: _kPath),
      type: type,
      response: response,
    );

Response<Map<String, dynamic>> _makeResponse({
  Map<String, dynamic>? data,
  int statusCode = _kStatusCode,
}) => Response(
  requestOptions: RequestOptions(path: _kPath),
  data: data,
  statusCode: statusCode,
);

void main() {
  late ErrorInterceptor interceptor;
  late _MockHandler handler;

  setUpAll(() {
    registerFallbackValue(
      DioException(
        requestOptions: RequestOptions(path: _kPath),
        type: DioExceptionType.unknown,
      ),
    );
  });

  setUp(() {
    interceptor = const ErrorInterceptor(defaultServerError: _kDefaultError);
    handler = _MockHandler();
  });

  group('ErrorInterceptor', () {
    group('network errors → NetworkException', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        test('$type rejects with NetworkException', () {
          // Arrange
          final err = _makeErr(type);

          // Act
          interceptor.onError(err, handler);

          // Assert
          final captured =
              verify(() => handler.reject(captureAny())).captured.single
                  as DioException;
          expect(captured.error, isA<NetworkException>());
        });
      }
    });

    group('badResponse → ServerException', () {
      test('uses status_message from response body', () {
        // Arrange
        final err = _makeErr(
          DioExceptionType.badResponse,
          response: _makeResponse(data: {'status_message': _kStatusMessage}),
        );

        // Act
        interceptor.onError(err, handler);

        // Assert
        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        final exception = captured.error as ServerException;
        expect(exception.message, equals(_kStatusMessage));
        expect(exception.statusCode, equals(_kStatusCode));
      });

      test('falls back to defaultServerError when status_message absent', () {
        // Arrange
        final err = _makeErr(
          DioExceptionType.badResponse,
          response: _makeResponse(data: {}),
        );

        // Act
        interceptor.onError(err, handler);

        // Assert
        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        expect(
          (captured.error as ServerException).message,
          equals(_kDefaultError),
        );
      });

      test('falls back to defaultServerError when body is not a Map', () {
        // Arrange
        final response = Response<String>(
          requestOptions: RequestOptions(path: _kPath),
          data: 'plain text',
          statusCode: _kStatusCode,
        );
        final err = _makeErr(DioExceptionType.badResponse, response: response);

        // Act
        interceptor.onError(err, handler);

        // Assert
        final captured =
            verify(() => handler.reject(captureAny())).captured.single
                as DioException;
        expect(
          (captured.error as ServerException).message,
          equals(_kDefaultError),
        );
      });
    });

    test('unknown error type calls handler.next', () {
      // Arrange
      final err = _makeErr(DioExceptionType.cancel);

      // Act
      interceptor.onError(err, handler);

      // Assert
      verify(() => handler.next(err)).called(1);
      verifyNever(() => handler.reject(any()));
    });
  });
}
