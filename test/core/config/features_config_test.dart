import 'dart:io' show Directory;

import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/config/features_config.dart';

void main() {
  group('FeaturesConfig', () {
    test('recordSession is false', () {
      // Arrange / Act
      const actual = FeaturesConfig.recordSession;

      // Assert
      expect(actual, isFalse);
    });

    test('mockAssetsPath has correct value', () {
      // Arrange
      const expected = 'lib/features/';

      // Act
      const actual = FeaturesConfig.mockAssetsPath;

      // Assert
      expect(actual, expected);
    });

    test(
      'mockPath falls back to Directory.current when PROJECT_ROOT not set',
      () {
        // Arrange
        final expected = '${Directory.current.path}/lib/features/';

        // Act
        final actual = FeaturesConfig.mockPath;

        // Assert
        expect(actual, expected);
      },
    );

    test('category feature name is correct', () {
      // Arrange
      const expected = 'category';

      // Act
      const actual = FeaturesConfig.category;

      // Assert
      expect(actual, expected);
    });

    test('home feature name is correct', () {
      // Arrange
      const expected = 'home';

      // Act
      const actual = FeaturesConfig.home;

      // Assert
      expect(actual, expected);
    });

    test('movieDetail feature name is correct', () {
      // Arrange
      const expected = 'movie_detail';

      // Act
      const actual = FeaturesConfig.movieDetail;

      // Assert
      expect(actual, expected);
    });

    test('moviesByCategory feature name is correct', () {
      // Arrange
      const expected = 'movies_by_category';

      // Act
      const actual = FeaturesConfig.moviesByCategory;

      // Assert
      expect(actual, expected);
    });

    test('popularMovies feature name is correct', () {
      // Arrange
      const expected = 'popular_movies';

      // Act
      const actual = FeaturesConfig.popularMovies;

      // Assert
      expect(actual, expected);
    });
  });
}
