import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/utils/mock_saver.dart';

void main() {
  group('endpointToFileName', () {
    test('converts /genre/movie/list', () {
      // Act & Assert
      expect(endpointToFileName('/genre/movie/list'), equals('genre_movie_list'));
    });

    test('converts /movie/popular', () {
      // Act & Assert
      expect(endpointToFileName('/movie/popular'), equals('movie_popular'));
    });

    test('converts /movie/550', () {
      // Act & Assert
      expect(endpointToFileName('/movie/550'), equals('movie_550'));
    });

    test('converts /discover/movie with query params', () {
      // Act & Assert
      expect(
        endpointToFileName('/discover/movie?with_genres=28&page=1'),
        equals('discover_movie'),
      );
    });

    test('strips special characters', () {
      // Act & Assert
      expect(endpointToFileName('/movie/550/credits'), equals('movie_550_credits'));
    });
  });
}
