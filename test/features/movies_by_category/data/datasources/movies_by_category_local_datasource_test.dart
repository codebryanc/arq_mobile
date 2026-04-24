import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_local_datasource.dart';

// Test constants
const _kCategoryId = 28;
const _kPage = 1;
const _kTotalPages = 5;
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kPosterPath = '/poster.jpg';
const _kVoteAverage = 8.4;
const _kReleaseDate = '1999-10-15';
const _kAssetPath =
    'lib/features/movies_by_category/data/mock/discover_movie_${_kCategoryId}_${_kPage}.json';

Map<String, dynamic> _buildMovieJson({String? posterPath = _kPosterPath}) => {
  'id': _kMovieId,
  'title': _kMovieTitle,
  'overview': '',
  'poster_path': posterPath,
  'vote_average': _kVoteAverage,
  'release_date': _kReleaseDate,
};

String _buildDiscoverJson(List<Map<String, dynamic>> results, int totalPages) =>
    jsonEncode({'results': results, 'total_pages': totalPages});

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

  late MoviesByCategoryLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = MoviesByCategoryLocalDataSourceImpl();
  });

  tearDown(_tearDownMockAssets);

  group('MoviesByCategoryLocalDataSource', () {
    group('getMoviesByCategory', () {
      test('returns movies and totalPages when asset exists', () async {
        // Arrange
        final json = _buildDiscoverJson([_buildMovieJson()], _kTotalPages);
        _setUpMockAssets({_kAssetPath: json});

        // Act
        final result = await dataSource.getMoviesByCategory(
          _kCategoryId,
          _kPage,
        );

        // Assert
        expect(result.movies, hasLength(1));
        expect(result.movies.first.id, equals(_kMovieId));
        expect(result.totalPages, equals(_kTotalPages));
      });

      test('filters out movies without poster_path', () async {
        // Arrange
        final json = _buildDiscoverJson([
          _buildMovieJson(),
          _buildMovieJson(posterPath: null),
          _buildMovieJson(posterPath: ''),
        ], _kTotalPages);
        _setUpMockAssets({_kAssetPath: json});

        // Act
        final result = await dataSource.getMoviesByCategory(
          _kCategoryId,
          _kPage,
        );

        // Assert
        expect(result.movies, hasLength(1));
        expect(result.movies.first.posterPath, equals(_kPosterPath));
      });

      test('returns empty record when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act
        final result = await dataSource.getMoviesByCategory(
          _kCategoryId,
          _kPage,
        );

        // Assert
        expect(result.movies, isEmpty);
        expect(result.totalPages, equals(0));
      });
    });
  });
}
