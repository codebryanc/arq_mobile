import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

// Test constants
const _kEndpoint = '/discover/movie';
const _kCategoryId = 28;
const _kPage = 1;
const _kTotalPages = 5;
const _kMovieId = 550;
const _kPosterPath = '/poster.jpg';
const _kErrorMessage = 'Connection error';

RequestOptions _options(String path) => RequestOptions(path: path);

Map<String, dynamic> _buildMovieJson({String? posterPath = _kPosterPath}) => {
  'id': _kMovieId,
  'title': 'Fight Club',
  'overview': '',
  'poster_path': posterPath,
  'vote_average': 8.4,
  'release_date': '1999-10-15',
};

Map<String, dynamic> _buildResponse(List<Map<String, dynamic>> results) => {
  'results': results,
  'total_pages': _kTotalPages,
};

void main() {
  late _MockDio mockDio;
  late MoviesByCategoryRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = _MockDio();
    dataSource = MoviesByCategoryRemoteDataSourceImpl(dio: mockDio);
  });

  group('MoviesByCategoryRemoteDataSource', () {
    group('getMoviesByCategory', () {
      test('returns movies and totalPages on success', () async {
        // Arrange
        when(
          () => mockDio.get(
            _kEndpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: _buildResponse([_buildMovieJson()]),
            statusCode: 200,
            requestOptions: _options(_kEndpoint),
          ),
        );

        // Act
        final result = await dataSource.getMoviesByCategory(
          _kCategoryId,
          _kPage,
        );

        // Assert
        expect(result.movies, hasLength(1));
        expect(result.totalPages, equals(_kTotalPages));
        expect(result.movies.first.id, equals(_kMovieId));
      });

      test('filters out movies with null or empty poster_path', () async {
        // Arrange
        when(
          () => mockDio.get(
            _kEndpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: _buildResponse([
              _buildMovieJson(),
              _buildMovieJson(posterPath: null),
              _buildMovieJson(posterPath: ''),
            ]),
            statusCode: 200,
            requestOptions: _options(_kEndpoint),
          ),
        );

        // Act
        final result = await dataSource.getMoviesByCategory(
          _kCategoryId,
          _kPage,
        );

        // Assert
        expect(result.movies, hasLength(1));
      });

      test('throws NetworkException when DioException wraps NetworkException', () {
        // Arrange
        when(
          () => mockDio.get(
            _kEndpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(_kEndpoint),
            error: const NetworkException(),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMoviesByCategory(_kCategoryId, _kPage),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws ServerException when DioException wraps ServerException', () {
        // Arrange
        when(
          () => mockDio.get(
            _kEndpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(_kEndpoint),
            error: ServerException(message: _kErrorMessage),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMoviesByCategory(_kCategoryId, _kPage),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws ServerException on generic DioException', () {
        // Arrange
        when(
          () => mockDio.get(
            _kEndpoint,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: _options(_kEndpoint),
            message: _kErrorMessage,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getMoviesByCategory(_kCategoryId, _kPage),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
