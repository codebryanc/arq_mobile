import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

// Test constants
const _kEndpoint = '/movie/popular';
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kPosterPath = '/poster.jpg';
const _kErrorMessage = 'Connection refused';

RequestOptions _requestOptions() => RequestOptions(path: _kEndpoint);

Map<String, dynamic> _buildMovieJson({String? posterPath = _kPosterPath}) => {
  'id': _kMovieId,
  'title': _kMovieTitle,
  'overview': '',
  'poster_path': posterPath,
  'vote_average': 8.0,
  'release_date': '1999-10-15',
};

Map<String, dynamic> _buildResultsResponse(List<Map<String, dynamic>> results) =>
    {'results': results};

void main() {
  late _MockDio mockDio;
  late PopularMoviesRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = _MockDio();
    dataSource = PopularMoviesRemoteDataSourceImpl(dio: mockDio);
  });

  group('PopularMoviesRemoteDataSource', () {
    group('getPopularMovies', () {
      test('returns movies that have a non-empty poster_path', () async {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenAnswer(
          (_) async => Response(
            data: _buildResultsResponse([
              _buildMovieJson(),
              _buildMovieJson(posterPath: null),
              _buildMovieJson(posterPath: ''),
            ]),
            statusCode: 200,
            requestOptions: _requestOptions(),
          ),
        );

        // Act
        final result = await dataSource.getPopularMovies();

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals(_kMovieId));
      });

      test('returns empty list when all movies lack poster_path', () async {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenAnswer(
          (_) async => Response(
            data: _buildResultsResponse([
              _buildMovieJson(posterPath: null),
            ]),
            statusCode: 200,
            requestOptions: _requestOptions(),
          ),
        );

        // Act
        final result = await dataSource.getPopularMovies();

        // Assert
        expect(result, isEmpty);
      });

      test('throws NetworkException when DioException wraps NetworkException', () {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getPopularMovies(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () {
        // Arrange
        final serverException = ServerException(message: _kErrorMessage);
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            error: serverException,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getPopularMovies(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () {
        // Arrange
        when(() => mockDio.get(_kEndpoint)).thenThrow(
          DioException(
            requestOptions: _requestOptions(),
            message: _kErrorMessage,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getPopularMovies(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
