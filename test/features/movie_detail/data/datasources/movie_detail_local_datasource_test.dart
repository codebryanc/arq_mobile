import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_local_datasource.dart';

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kOverview = 'A depressed man forms a fight club.';
const _kVoteAverage = 8.4;
const _kPosterPath = '/poster.jpg';
const _kBackdropPath = '/backdrop.jpg';
const _kReleaseDate = '1999-10-15';
const _kRuntime = 139;
const _kGenreName = 'Drama';
const _kGenreId = 18;
const _kActorId = 1;
const _kActorName = 'Brad Pitt';
const _kCharacter = 'Tyler Durden';
const _kProfilePath = '/brad.jpg';
const _kImageCount = 11;
const _kImageLimit = 10;

const _kDetailAssetPath =
    'lib/features/movie_detail/data/mock/movie_$_kMovieId.json';
const _kCreditsAssetPath =
    'lib/features/movie_detail/data/mock/movie_${_kMovieId}_credits.json';
const _kImagesAssetPath =
    'lib/features/movie_detail/data/mock/movie_${_kMovieId}_images.json';

String _buildDetailJson() => jsonEncode({
  'id': _kMovieId,
  'title': _kMovieTitle,
  'overview': _kOverview,
  'vote_average': _kVoteAverage,
  'poster_path': _kPosterPath,
  'backdrop_path': _kBackdropPath,
  'release_date': _kReleaseDate,
  'runtime': _kRuntime,
  'genres': [
    {'id': _kGenreId, 'name': _kGenreName},
  ],
});

String _buildCreditsJson() => jsonEncode({
  'cast': [
    {
      'id': _kActorId,
      'name': _kActorName,
      'character': _kCharacter,
      'profile_path': _kProfilePath,
    },
    {
      'id': 2,
      'name': 'No Photo',
      'character': 'Nobody',
      'profile_path': null,
    },
  ],
});

String _buildImagesJson(int count) => jsonEncode({
  'backdrops': List.generate(
    count,
    (i) => {'file_path': '/image_$i.jpg'},
  ),
});

void _setUpMockAssets(Map<String, String> assetContents) {
  final manifestMap = {
    for (final k in assetContents.keys) k: [k],
  };
  final binaryManifest =
      const StandardMessageCodec().encodeMessage(manifestMap)!;
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

  late MovieDetailLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = MovieDetailLocalDataSourceImpl();
  });

  tearDown(_tearDownMockAssets);

  group('MovieDetailLocalDataSource', () {
    group('getMovieDetail', () {
      test('returns MovieDetailModel when asset exists', () async {
        // Arrange
        _setUpMockAssets({_kDetailAssetPath: _buildDetailJson()});

        // Act
        final result = await dataSource.getMovieDetail(_kMovieId);

        // Assert
        expect(result.id, equals(_kMovieId));
        expect(result.title, equals(_kMovieTitle));
        expect(result.runtime, equals(_kRuntime));
        expect(result.genres, contains(_kGenreName));
      });

      test('throws ServerException when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act & Assert
        expect(
          () => dataSource.getMovieDetail(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getMovieCast', () {
      test('returns actors with profile_path, filters out null profiles',
          () async {
        // Arrange
        _setUpMockAssets({_kCreditsAssetPath: _buildCreditsJson()});

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.name, equals(_kActorName));
        expect(result.first.profilePath, equals(_kProfilePath));
      });

      test('limits cast to 20 actors', () async {
        // Arrange
        final credits = jsonEncode({
          'cast': List.generate(
            25,
            (i) => {
              'id': i,
              'name': 'Actor $i',
              'character': 'Role $i',
              'profile_path': '/actor_$i.jpg',
            },
          ),
        });
        _setUpMockAssets({_kCreditsAssetPath: credits});

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result, hasLength(20));
      });

      test('returns empty list when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getMovieImages', () {
      test('returns backdrops limited to $_kImageLimit items', () async {
        // Arrange
        _setUpMockAssets({
          _kImagesAssetPath: _buildImagesJson(_kImageCount),
        });

        // Act
        final result = await dataSource.getMovieImages(_kMovieId);

        // Assert
        expect(result, hasLength(_kImageLimit));
        expect(result.first.filePath, equals('/image_0.jpg'));
      });

      test('returns empty list when asset not found', () async {
        // Arrange
        _setUpMockAssets({});

        // Act
        final result = await dataSource.getMovieImages(_kMovieId);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
