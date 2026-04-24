import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('baseUrl has correct value', () {
      // Arrange
      const expected = 'https://api.themoviedb.org/3';

      // Act
      const actual = AppConfig.baseUrl;

      // Assert
      expect(actual, expected);
    });

    test('imageBaseUrl has correct value', () {
      // Arrange
      const expected = 'https://image.tmdb.org/t/p/w300';

      // Act
      const actual = AppConfig.imageBaseUrl;

      // Assert
      expect(actual, expected);
    });

    test('imageBackdropUrl has correct value', () {
      // Arrange
      const expected = 'https://image.tmdb.org/t/p/w500';

      // Act
      const actual = AppConfig.imageBackdropUrl;

      // Assert
      expect(actual, expected);
    });

    test('connectTimeout is 10 seconds', () {
      // Arrange
      const expected = Duration(seconds: 10);

      // Act
      const actual = AppConfig.connectTimeout;

      // Assert
      expect(actual, expected);
    });

    test('receiveTimeout is 10 seconds', () {
      // Arrange
      const expected = Duration(seconds: 10);

      // Act
      const actual = AppConfig.receiveTimeout;

      // Assert
      expect(actual, expected);
    });

    test('apiKey is a String', () {
      // Arrange / Act
      const actual = AppConfig.apiKey;

      // Assert
      expect(actual, isA<String>());
    });
  });
}
