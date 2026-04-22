import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/utils/movie_format.dart';

// Test constants
const _kRuntimeWithHours = 125;
const _kRuntimeOnlyMinutes = 45;
const _kRuntimeZero = 0;
const _kRuntimeExactHour = 60;

const _kExpectedRuntimeWithHours = '2h 5m';
const _kExpectedRuntimeOnlyMinutes = '45m';
const _kExpectedRuntimeZero = '0m';
const _kExpectedRuntimeExactHour = '1h 0m';

const _kReleaseDateFull = '2023-07-14';
const _kReleaseDateExactlyFour = '2023';
const _kReleaseDateShort = '20';

const _kExpectedYearFull = '2023';
const _kExpectedYearShort = '20';

void main() {
  group('MovieFormat', () {
    group('runtime', () {
      test('formats hours and minutes when runtime exceeds 60 minutes', () {
        // Arrange — _kRuntimeWithHours = 125 min

        // Act
        final result = MovieFormat.runtime(_kRuntimeWithHours);

        // Assert
        expect(result, equals(_kExpectedRuntimeWithHours));
      });

      test('formats only minutes when runtime is under 60 minutes', () {
        // Arrange — _kRuntimeOnlyMinutes = 45 min

        // Act
        final result = MovieFormat.runtime(_kRuntimeOnlyMinutes);

        // Assert
        expect(result, equals(_kExpectedRuntimeOnlyMinutes));
      });

      test('formats zero runtime as 0m', () {
        // Arrange — _kRuntimeZero = 0

        // Act
        final result = MovieFormat.runtime(_kRuntimeZero);

        // Assert
        expect(result, equals(_kExpectedRuntimeZero));
      });

      test('formats exactly one hour with 0 remaining minutes', () {
        // Arrange — _kRuntimeExactHour = 60 min

        // Act
        final result = MovieFormat.runtime(_kRuntimeExactHour);

        // Assert
        expect(result, equals(_kExpectedRuntimeExactHour));
      });
    });

    group('releaseYear', () {
      test('extracts first 4 characters from a full date string', () {
        // Arrange — _kReleaseDateFull = '2023-07-14'

        // Act
        final result = MovieFormat.releaseYear(_kReleaseDateFull);

        // Assert
        expect(result, equals(_kExpectedYearFull));
      });

      test('returns the string as-is when it has exactly 4 characters', () {
        // Arrange — _kReleaseDateExactlyFour = '2023'

        // Act
        final result = MovieFormat.releaseYear(_kReleaseDateExactlyFour);

        // Assert
        expect(result, equals(_kExpectedYearFull));
      });

      test('returns the string as-is when shorter than 4 characters', () {
        // Arrange — _kReleaseDateShort = '20'

        // Act
        final result = MovieFormat.releaseYear(_kReleaseDateShort);

        // Assert
        expect(result, equals(_kExpectedYearShort));
      });
    });
  });
}
