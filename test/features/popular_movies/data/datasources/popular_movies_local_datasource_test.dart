import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_local_datasource.dart';

// Test constants
const _kAssetPath =
    'lib/features/popular_movies/data/mock/movie_popular_test.json';
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kPosterPath = '/poster.jpg';
const _kVoteAverage = 8.4;
const _kReleaseDate = '1999-10-15';

Map<String, dynamic> _buildMovieJson({String? posterPath = _kPosterPath}) => {
  'id': _kMovieId,
  'title': _kMovieTitle,
  'overview': '',
  'poster_path': posterPath,
  'vote_average': _kVoteAverage,
  'release_date': _kReleaseDate,
};

String _buildResultsJson(List<Map<String, dynamic>> results) =>
    jsonEncode({'results': results});

void _setUpMockAssets(Map<String, String> assetContents) {
  final manifestMap = {
    for (final k in assetContents.keys) k: [k],
  };
  final binaryManifest = const StandardMessageCodec().encodeMessage(
    manifestMap,
  )!;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'AssetManifest.bin') return binaryManifest;
        final content = assetContents[key];
        if (content == null) return null;
        return ByteData.view(Uint8List.fromList(utf8.encode(content)).buffer);
      });
}

void _tearDownMockAssets() {
  rootBundle.clear();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PopularMoviesLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = PopularMoviesLocalDataSourceImpl();
  });

  tearDown(_tearDownMockAssets);

  group('PopularMoviesLocalDataSource', () {
    group('getPopularMovies', () {
      test('returns movies that have a non-empty poster_path', () async {
        // Arrange
        final json = _buildResultsJson([
          _buildMovieJson(),
          _buildMovieJson(posterPath: null),
          _buildMovieJson(posterPath: ''),
        ]);
        _setUpMockAssets({_kAssetPath: json});

        // Act
        final result = await dataSource.getPopularMovies();

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals(_kMovieId));
        expect(result.first.title, equals(_kMovieTitle));
      });

      test('returns empty list when all movies lack poster_path', () async {
        // Arrange
        final json = _buildResultsJson([_buildMovieJson(posterPath: null)]);
        _setUpMockAssets({_kAssetPath: json});

        // Act
        final result = await dataSource.getPopularMovies();

        // Assert
        expect(result, isEmpty);
      });

      test('throws ServerException when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act & Assert
        expect(
          () => dataSource.getPopularMovies(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
