import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_local_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_remote_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/data/repositories/movies_by_category_repository_impl.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

class _MockRemote extends Mock implements MoviesByCategoryRemoteDataSource {}

class _MockLocal extends Mock implements MoviesByCategoryLocalDataSource {}

// Test constants
const _kCategoryId = 28;
const _kPage = 1;
const _kTotalPages = 5;
const _kMovieId = 550;
const _kErrorMessage = 'Server error';
const _kStatusCode = 500;

final _kMovie = MovieModel(
  id: _kMovieId,
  title: 'Fight Club',
  overview: '',
  posterPath: '/poster.jpg',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
);

final _kRemoteRecord = (movies: [_kMovie], totalPages: _kTotalPages);
final _kLocalRecord = (movies: [_kMovie], totalPages: _kTotalPages);

void main() {
  late _MockRemote mockRemote;
  late _MockLocal mockLocal;
  late MoviesByCategoryRepositoryImpl repository;

  setUp(() {
    mockRemote = _MockRemote();
    mockLocal = _MockLocal();
    repository = MoviesByCategoryRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('MoviesByCategoryRepositoryImpl', () {
    group('getMoviesByCategory — offline', () {
      test('returns Right with local data and skips remote', () async {
        // Arrange
        when(() => mockLocal.getMoviesByCategory(_kCategoryId, _kPage))
            .thenAnswer((_) async => _kLocalRecord);

        // Act
        final result = await repository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: false,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (record) {
          final (movies, totalPages) = record;
          expect(movies, equals(_kLocalRecord.movies));
          expect(totalPages, equals(_kTotalPages));
        });
        verifyNever(() => mockRemote.getMoviesByCategory(any(), any()));
      });
    });

    group('getMoviesByCategory — online', () {
      test('returns Right with remote data on success', () async {
        // Arrange
        when(() => mockRemote.getMoviesByCategory(_kCategoryId, _kPage))
            .thenAnswer((_) async => _kRemoteRecord);

        // Act
        final result = await repository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (record) {
          final (movies, totalPages) = record;
          expect(movies.first.id, equals(_kMovieId));
          expect(totalPages, equals(_kTotalPages));
        });
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        // Arrange
        when(() => mockRemote.getMoviesByCategory(_kCategoryId, _kPage))
            .thenThrow(const NetworkException());

        // Act
        final result = await repository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        );

        // Assert
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('expected Left'),
        );
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        // Arrange
        when(() => mockRemote.getMoviesByCategory(_kCategoryId, _kPage))
            .thenThrow(
              ServerException(message: _kErrorMessage, statusCode: _kStatusCode),
            );

        // Act
        final result = await repository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        );

        // Assert
        result.fold(
          (f) {
            expect(f, isA<ServerFailure>());
            final sf = f as ServerFailure;
            expect(sf.message, equals(_kErrorMessage));
            expect(sf.statusCode, equals(_kStatusCode));
          },
          (_) => fail('expected Left'),
        );
      });
    });
  });
}
