import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/network/dio_client.dart';
import 'package:arq_mobile/core/network/dio_error_interceptor.dart';

const _kDefaultError = 'Server error';

void main() {
  group('DioClient.create', () {
    test('returns a Dio instance', () {
      // Act
      final dio = DioClient.create(defaultServerError: _kDefaultError);

      // Assert
      expect(dio, isA<Dio>());
    });

    test('includes ErrorInterceptor', () {
      // Act
      final dio = DioClient.create(defaultServerError: _kDefaultError);

      // Assert
      expect(
        dio.interceptors.any((i) => i is ErrorInterceptor),
        isTrue,
      );
    });
  });
}
