import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/failures.dart';

// Test constants
const _kMessage = 'Internal server error';
const _kStatusCode = 500;

void main() {
  group('ServerFailure', () {
    test('stores message and statusCode', () {
      // Arrange & Act
      const failure = ServerFailure(_kMessage, statusCode: _kStatusCode);

      // Assert
      expect(failure.message, equals(_kMessage));
      expect(failure.statusCode, equals(_kStatusCode));
    });

    test('statusCode defaults to null when not provided', () {
      // Arrange & Act
      const failure = ServerFailure(_kMessage);

      // Assert
      expect(failure.statusCode, isNull);
    });

    test('is a Failure', () {
      // Arrange & Act
      const failure = ServerFailure(_kMessage);

      // Assert
      expect(failure, isA<Failure>());
    });
  });

  group('NetworkFailure', () {
    test('can be instantiated', () {
      // Arrange & Act
      const failure = NetworkFailure();

      // Assert
      expect(failure, isA<Failure>());
    });
  });

  group('CacheFailure', () {
    test('stores message', () {
      // Arrange & Act
      const failure = CacheFailure(_kMessage);

      // Assert
      expect(failure.message, equals(_kMessage));
    });

    test('is a Failure', () {
      // Arrange & Act
      const failure = CacheFailure(_kMessage);

      // Assert
      expect(failure, isA<Failure>());
    });
  });

  group('NotFoundFailure', () {
    test('can be instantiated', () {
      // Arrange & Act
      const failure = NotFoundFailure();

      // Assert
      expect(failure, isA<Failure>());
    });
  });
}
