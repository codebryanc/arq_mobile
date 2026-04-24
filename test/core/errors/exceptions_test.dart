import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';

// Test constants
const _kMessage = 'Something went wrong';
const _kStatusCode = 404;
const _kStatusCodeServer = 500;

void main() {
  group('ServerException', () {
    test('stores message and statusCode', () {
      // Arrange & Act
      const exception = ServerException(
        message: _kMessage,
        statusCode: _kStatusCode,
      );

      // Assert
      expect(exception.message, equals(_kMessage));
      expect(exception.statusCode, equals(_kStatusCode));
    });

    test('statusCode defaults to null when not provided', () {
      // Arrange & Act
      const exception = ServerException(message: _kMessage);

      // Assert
      expect(exception.statusCode, isNull);
    });

    test('is an Exception', () {
      // Arrange & Act
      const exception = ServerException(
        message: _kMessage,
        statusCode: _kStatusCodeServer,
      );

      // Assert
      expect(exception, isA<Exception>());
    });
  });

  group('NetworkException', () {
    test('can be instantiated', () {
      // Arrange & Act
      const exception = NetworkException();

      // Assert
      expect(exception, isA<Exception>());
    });
  });

  group('CacheException', () {
    test('stores message', () {
      // Arrange & Act
      const exception = CacheException(message: _kMessage);

      // Assert
      expect(exception.message, equals(_kMessage));
    });

    test('is an Exception', () {
      // Arrange & Act
      const exception = CacheException(message: _kMessage);

      // Assert
      expect(exception, isA<Exception>());
    });
  });
}
