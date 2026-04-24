import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kCastLimit = 20;
const _kImagesLimit = 10;
const _kActorId = 819;
const _kActorName = 'Edward Norton';
const _kProfilePath = '/profile.jpg';
const _kFilePath = '/backdrop.jpg';
const _kErrorMessage = 'Request failed';

RequestOptions _options(String path) => RequestOptions(path: path);

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

void main() {
  late _MockDio mockDio;
  late MovieDetailRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = _MockDio();
    dataSource = MovieDetailRemoteDataSourceImpl(dio: mockDio);
  });

  group('MovieDetailRemoteDataSource', () {
    group('getMovieDetail', () {
      test('returns MovieDetailModel on success', () async {
        // Arrange
        final endpoint = '/movie/$_kMovieId';
        when(() => mockDio.get(endpoint)).thenAnswer(
          (_) async => Response(
            data: _buildDetailJson(),
            statusCode: 200,
            requestOptions: _options(endpoint),
          ),
        );

        // Act
        final result = await dataSource.getMovieDetail(_kMovieId);

        // Assert
        expect(result.id, equals(_kMovieId));
        expect(result.title, equals(_kMovieTitle));
      });

      test('throws NetworkException when DioException wraps NetworkException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieDetail(_kMovieId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: ServerException(message: _kErrorMessage),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieDetail(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            message: _kErrorMessage,
          ),
        );

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
        final endpoint = '/movie/$_kMovieId/credits';
        when(() => mockDio.get(endpoint)).thenAnswer(
          (_) async => Response(
            data: {
              'cast': [
                _buildActorJson(),
                _buildActorJson(profilePath: null),
              ],
            },
            statusCode: 200,
            requestOptions: _options(endpoint),
          ),
        );

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals(_kActorId));
      });

      test('limits cast to $_kCastLimit actors', () async {
        // Arrange
        final endpoint = '/movie/$_kMovieId/credits';
        final actors = List.generate(
          _kCastLimit + 5,
          (_) => _buildActorJson(),
        );
        when(() => mockDio.get(endpoint)).thenAnswer(
          (_) async => Response(
            data: {'cast': actors},
            statusCode: 200,
            requestOptions: _options(endpoint),
          ),
        );

        // Act
        final result = await dataSource.getMovieCast(_kMovieId);

        // Assert
        expect(result.length, lessThanOrEqualTo(_kCastLimit));
      });

      test('throws NetworkException when DioException wraps NetworkException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/credits';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieCast(_kMovieId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/credits';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: ServerException(message: _kErrorMessage),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieCast(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/credits';
        when(() => mockDio.get(endpoint)).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            message: _kErrorMessage,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieCast(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getMovieImages', () {
      test('returns backdrops limited to $_kImagesLimit items', () async {
        // Arrange
        final endpoint = '/movie/$_kMovieId/images';
        final backdrops = List.generate(
          _kImagesLimit + 5,
          (_) => _buildImageJson(),
        );
        when(
          () => mockDio.get(
            endpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'backdrops': backdrops},
            statusCode: 200,
            requestOptions: _options(endpoint),
          ),
        );

        // Act
        final result = await dataSource.getMovieImages(_kMovieId);

        // Assert
        expect(result.length, lessThanOrEqualTo(_kImagesLimit));
      });

      test('throws NetworkException when DioException wraps NetworkException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/images';
        when(
          () => mockDio.get(
            endpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieImages(_kMovieId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/images';
        when(
          () => mockDio.get(
            endpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            error: ServerException(message: _kErrorMessage),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieImages(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () {
        // Arrange
        final endpoint = '/movie/$_kMovieId/images';
        when(
          () => mockDio.get(
            endpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(endpoint),
            message: _kErrorMessage,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMovieImages(_kMovieId),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
