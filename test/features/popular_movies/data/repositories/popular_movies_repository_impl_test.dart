import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_local_datasource.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_remote_datasource.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';
import 'package:arq_mobile/features/popular_movies/data/repositories/popular_movies_repository_impl.dart';

class _MockRemote extends Mock implements PopularMoviesRemoteDataSource {}

class _MockLocal extends Mock implements PopularMoviesLocalDataSource {}

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';
const _kErrorMessage = 'Internal error';
const _kStatusCode = 500;

final _kMovieModel = MovieModel(
  id: _kMovieId,
  title: _kMovieTitle,
  overview: '',
  posterPath: '/poster.jpg',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
);
final _kMovieList = [_kMovieModel];

void main() {
  late _MockRemote mockRemote;
  late _MockLocal mockLocal;
  late PopularMoviesRepositoryImpl repository;

  setUp(() {
    mockRemote = _MockRemote();
    mockLocal = _MockLocal();
    repository = PopularMoviesRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('PopularMoviesRepositoryImpl', () {
    group('getPopularMovies — offline', () {
      test('returns Right with local data and skips remote', () async {
        // Arrange
        when(
          () => mockLocal.getPopularMovies(),
        ).thenAnswer((_) async => _kMovieList);

        // Act
        final result = await repository.getPopularMovies(isOnline: false);

        // Assert
        expect(result, isA<Right<Failure, List<dynamic>>>());
        result.fold((_) => fail('expected Right'), (movies) {
          expect(movies, equals(_kMovieList));
        });
        verifyNever(() => mockRemote.getPopularMovies());
      });
    });

    group('getPopularMovies — online', () {
      test('returns Right with remote data on success', () async {
        // Arrange
        when(
          () => mockRemote.getPopularMovies(),
        ).thenAnswer((_) async => _kMovieList);

        // Act
        final result = await repository.getPopularMovies(isOnline: true);

        // Assert
        result.fold((_) => fail('expected Right'), (movies) {
          expect(movies, equals(_kMovieList));
        });
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        // Arrange
        when(
          () => mockRemote.getPopularMovies(),
        ).thenThrow(const NetworkException());

        // Act
        final result = await repository.getPopularMovies(isOnline: true);

        // Assert
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('expected Left'),
        );
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        // Arrange
        when(() => mockRemote.getPopularMovies()).thenThrow(
          ServerException(message: _kErrorMessage, statusCode: _kStatusCode),
        );

        // Act
        final result = await repository.getPopularMovies(isOnline: true);

        // Assert
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          final sf = failure as ServerFailure;
          expect(sf.message, equals(_kErrorMessage));
          expect(sf.statusCode, equals(_kStatusCode));
        }, (_) => fail('expected Left'));
      });
    });
  });
}
