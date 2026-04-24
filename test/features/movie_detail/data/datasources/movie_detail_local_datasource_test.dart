import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_local_datasource.dart';

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kActorId = 819;
const _kActorName = 'Edward Norton';
const _kProfilePath = '/profile.jpg';
const _kFilePath = '/backdrop.jpg';
const _kCastLimit = 20;
const _kImagesLimit = 10;

const _kDetailAsset =
    'lib/features/movie_detail/data/mock/movie_${_kMovieId}_test.json';
const _kCreditsAsset =
    'lib/features/movie_detail/data/mock/movie_${_kMovieId}_credits_test.json';
const _kImagesAsset =
    'lib/features/movie_detail/data/mock/movie_${_kMovieId}_images_test.json';

Map<String, dynamic> _buildDetailJson() => {
  'id': _kMovieId,
  'title': _kMovieTitle,
  'overview': '',
  'vote_average': 8.4,
  'poster_path': '/poster.jpg',
  'backdrop_path': '/backdrop.jpg',
  'release_date': '1999-10-15',
  'runtime': 139,
  'genres': [
    {'id': 18, 'name': 'Drama'},
  ],
};

Map<String, dynamic> _buildActorJson({String? profilePath = _kProfilePath}) => {
  'id': _kActorId,
  'name': _kActorName,
  'character': 'The Narrator',
  'profile_path': profilePath,
};

Map<String, dynamic> _buildImageJson() => {'file_path': _kFilePath};

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

  late MovieDetailLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = MovieDetailLocalDataSourceImpl();
  });

  tearDown(_tearDownMockAssets);

  group('MovieDetailLocalDataSource', () {
    group('getMovieDetail', () {
      test('returns MovieDetailModel when asset exists', () async {
        // Arrange
        _setUpMockAssets({_kDetailAsset: jsonEncode(_buildDetailJson())});

        // Act
        final result = await dataSource.getMovieDetail(_kMovieId);

        // Assert
        expect(result.id, equals(_kMovieId));
        expect(result.title, equals(_kMovieTitle));
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
      test('returns actors that have a profile_path', () async {
        // Arrange
        final json = jsonEncode({
          'cast': [_buildActorJson(), _buildActorJson(profilePath: null)],
        });
        _setUpMockAssets({_kCreditsAsset: json});

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals(_kActorId));
      });

      test('limits cast to $_kCastLimit actors', () async {
        // Arrange
        final actors = List.generate(_kCastLimit + 5, (_) => _buildActorJson());
        _setUpMockAssets({
          _kCreditsAsset: jsonEncode({'cast': actors}),
        });

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result.length, lessThanOrEqualTo(_kCastLimit));
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
      test('returns backdrops limited to $_kImagesLimit items', () async {
        // Arrange
        final backdrops = List.generate(
          _kImagesLimit + 5,
          (_) => _buildImageJson(),
        );
        _setUpMockAssets({
          _kImagesAsset: jsonEncode({'backdrops': backdrops}),
        });

        // Act
        final result = await dataSource.getMovieImages(_kMovieId);

        // Assert
        expect(result.length, lessThanOrEqualTo(_kImagesLimit));
      });

      test('returns correct filePath from backdrop', () async {
        // Arrange
        _setUpMockAssets({
          _kImagesAsset: jsonEncode({
            'backdrops': [_buildImageJson()],
          }),
        });

        // Act
        final result = await dataSource.getMovieImages(_kMovieId);

        // Assert
        expect(result.first.filePath, equals(_kFilePath));
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
