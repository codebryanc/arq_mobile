import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kMovieOverview =
    'An insomniac office worker forms an underground fight club.';
const _kMoviePosterPath = '/poster.jpg';
const _kMovieVoteAverage = 8.4;
const _kMovieVoteAverageAsInt = 8;
const _kMovieVoteAverageFromInt = 8.0;
const _kMovieReleaseDate = '1999-10-15';

void main() {
  group('MovieModel', () {
    group('fromJson', () {
      test('maps all fields correctly', () {
        // Arrange
        final json = {
          'id': _kMovieId,
          'title': _kMovieTitle,
          'overview': _kMovieOverview,
          'poster_path': _kMoviePosterPath,
          'vote_average': _kMovieVoteAverage,
          'release_date': _kMovieReleaseDate,
        };

        // Act
        final result = MovieModel.fromJson(json);

        // Assert
        expect(result.id, equals(_kMovieId));
        expect(result.title, equals(_kMovieTitle));
        expect(result.overview, equals(_kMovieOverview));
        expect(result.posterPath, equals(_kMoviePosterPath));
        expect(result.voteAverage, equals(_kMovieVoteAverage));
        expect(result.releaseDate, equals(_kMovieReleaseDate));
      });

      test('defaults posterPath to empty string when poster_path is null', () {
        // Arrange
        final json = {
          'id': _kMovieId,
          'title': _kMovieTitle,
          'overview': _kMovieOverview,
          'poster_path': null,
          'vote_average': _kMovieVoteAverage,
          'release_date': _kMovieReleaseDate,
        };

        // Act
        final result = MovieModel.fromJson(json);

        // Assert
        expect(result.posterPath, isEmpty);
      });

      test(
        'defaults releaseDate to empty string when release_date is null',
        () {
          // Arrange
          final json = {
            'id': _kMovieId,
            'title': _kMovieTitle,
            'overview': _kMovieOverview,
            'poster_path': _kMoviePosterPath,
            'vote_average': _kMovieVoteAverage,
            'release_date': null,
          };

          // Act
          final result = MovieModel.fromJson(json);

          // Assert
          expect(result.releaseDate, isEmpty);
        },
      );

      test('converts vote_average from int to double', () {
        // Arrange
        final json = {
          'id': _kMovieId,
          'title': _kMovieTitle,
          'overview': _kMovieOverview,
          'poster_path': _kMoviePosterPath,
          'vote_average': _kMovieVoteAverageAsInt,
          'release_date': _kMovieReleaseDate,
        };

        // Act
        final result = MovieModel.fromJson(json);

        // Assert
        expect(result.voteAverage, equals(_kMovieVoteAverageFromInt));
        expect(result.voteAverage, isA<double>());
      });
    });
  });
}
