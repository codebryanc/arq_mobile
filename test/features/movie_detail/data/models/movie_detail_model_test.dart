import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/movie_detail/data/models/movie_detail_model.dart';

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kMovieOverview =
    'An insomniac office worker forms an underground fight club.';
const _kMovieVoteAverage = 8.4;
const _kMoviePosterPath = '/poster.jpg';
const _kMovieBackdropPath = '/backdrop.jpg';
const _kMovieReleaseDate = '1999-10-15';
const _kMovieRuntime = 139;
const _kGenreAction = 'Action';
const _kGenreDrama = 'Drama';

Map<String, dynamic> _buildJson({
  int? id,
  String? title,
  String? overview,
  double? voteAverage,
  String? posterPath,
  String? backdropPath,
  String? releaseDate,
  int? runtime,
  List<Map<String, dynamic>>? genres,
}) => {
  'id': id ?? _kMovieId,
  'title': title ?? _kMovieTitle,
  'overview': overview,
  'vote_average': voteAverage ?? _kMovieVoteAverage,
  'poster_path': posterPath,
  'backdrop_path': backdropPath,
  'release_date': releaseDate,
  'runtime': runtime,
  'genres':
      genres ??
      [
        {'id': 28, 'name': _kGenreAction},
        {'id': 18, 'name': _kGenreDrama},
      ],
};

void main() {
  group('MovieDetailModel', () {
    group('fromJson', () {
      test('maps all fields correctly', () {
        // Arrange
        final json = _buildJson(
          overview: _kMovieOverview,
          posterPath: _kMoviePosterPath,
          backdropPath: _kMovieBackdropPath,
          releaseDate: _kMovieReleaseDate,
          runtime: _kMovieRuntime,
        );

        // Act
        final result = MovieDetailModel.fromJson(json);

        // Assert
        expect(result.id, equals(_kMovieId));
        expect(result.title, equals(_kMovieTitle));
        expect(result.overview, equals(_kMovieOverview));
        expect(result.voteAverage, equals(_kMovieVoteAverage));
        expect(result.posterPath, equals(_kMoviePosterPath));
        expect(result.backdropPath, equals(_kMovieBackdropPath));
        expect(result.releaseDate, equals(_kMovieReleaseDate));
        expect(result.runtime, equals(_kMovieRuntime));
      });

      test('extracts genre names from genres list', () {
        // Arrange
        final json = _buildJson(
          genres: [
            {'id': 28, 'name': _kGenreAction},
            {'id': 18, 'name': _kGenreDrama},
          ],
        );

        // Act
        final result = MovieDetailModel.fromJson(json);

        // Assert
        expect(result.genres, equals([_kGenreAction, _kGenreDrama]));
      });

      test('returns empty genres list when genres array is empty', () {
        // Arrange
        final json = _buildJson(genres: []);

        // Act
        final result = MovieDetailModel.fromJson(json);

        // Assert
        expect(result.genres, isEmpty);
      });

      test('defaults nullable fields to empty string or zero when null', () {
        // Arrange
        final json = _buildJson(
          overview: null,
          posterPath: null,
          backdropPath: null,
          releaseDate: null,
          runtime: null,
        );

        // Act
        final result = MovieDetailModel.fromJson(json);

        // Assert
        expect(result.overview, isEmpty);
        expect(result.posterPath, isEmpty);
        expect(result.backdropPath, isEmpty);
        expect(result.releaseDate, isEmpty);
        expect(result.runtime, equals(0));
      });
    });
  });
}
