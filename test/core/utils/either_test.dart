import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/utils/either.dart';

// Test constants
const _kLeftValue = 'error';
const _kRightValue = 42;
const _kFoldLeftResult = 'was left';
const _kFoldRightResult = 'was right';

void main() {
  group('Either', () {
    group('Left', () {
      test('holds the left value', () {
        // Arrange & Act
        const either = Left<String, int>(_kLeftValue);

        // Assert
        expect(either.value, equals(_kLeftValue));
      });

      test('fold invokes onLeft with the value', () {
        // Arrange
        const either = Left<String, int>(_kLeftValue);

        // Act
        final result = either.fold(
          (_) => _kFoldLeftResult,
          (_) => _kFoldRightResult,
        );

        // Assert
        expect(result, equals(_kFoldLeftResult));
      });
    });

    group('Right', () {
      test('holds the right value', () {
        // Arrange & Act
        const either = Right<String, int>(_kRightValue);

        // Assert
        expect(either.value, equals(_kRightValue));
      });

      test('fold invokes onRight with the value', () {
        // Arrange
        const either = Right<String, int>(_kRightValue);

        // Act
        final result = either.fold(
          (_) => _kFoldLeftResult,
          (_) => _kFoldRightResult,
        );

        // Assert
        expect(result, equals(_kFoldRightResult));
      });
    });

    group('fold', () {
      test('Left passes its value to onLeft callback', () {
        // Arrange
        const either = Left<String, int>(_kLeftValue);
        String? captured;

        // Act
        either.fold((v) => captured = v, (_) {});

        // Assert
        expect(captured, equals(_kLeftValue));
      });

      test('Right passes its value to onRight callback', () {
        // Arrange
        const either = Right<String, int>(_kRightValue);
        int? captured;

        // Act
        either.fold((_) {}, (v) => captured = v);

        // Assert
        expect(captured, equals(_kRightValue));
      });
    });
  });
}
