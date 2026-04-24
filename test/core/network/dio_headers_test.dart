import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/config/app_config.dart';
import 'package:arq_mobile/core/constants/api_constants.dart';
import 'package:arq_mobile/core/network/dio_headers.dart';

void main() {
  group('DioHeaders.baseOptions', () {
    test('uses AppConfig baseUrl', () {
      // Act
      final options = DioHeaders.baseOptions;

      // Assert
      expect(options.baseUrl, equals(AppConfig.baseUrl));
    });

    test('uses AppConfig timeouts', () {
      // Act
      final options = DioHeaders.baseOptions;

      // Assert
      expect(options.connectTimeout, equals(AppConfig.connectTimeout));
      expect(options.receiveTimeout, equals(AppConfig.receiveTimeout));
    });

    test('includes api_key and language query parameters', () {
      // Act
      final options = DioHeaders.baseOptions;

      // Assert
      expect(
        options.queryParameters,
        containsPair('language', ApiConstants.language),
      );
      expect(options.queryParameters, contains('api_key'));
    });

    test('includes JSON content-type and accept headers', () {
      // Act
      final options = DioHeaders.baseOptions;

      // Assert
      expect(options.headers, containsPair('Content-Type', 'application/json'));
      expect(options.headers, containsPair('Accept', 'application/json'));
    });
  });
}
