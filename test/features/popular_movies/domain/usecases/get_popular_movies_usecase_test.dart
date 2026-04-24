import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';
import 'package:arq_mobile/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import 'package:arq_mobile/features/popular_movies/domain/usecases/get_popular_movies_usecase.dart';

class _MockPopularMoviesRepository extends Mock
    implements PopularMoviesRepository {}

// Test constants
const _kMovieId = 550;
const _kMovieTitle = 'Fight Club';

final _kMovie = Movie(
  id: _kMovieId,
  title: _kMovieTitle,
  overview: '',
  posterPath: '/poster.jpg',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
);
final _kMovieList = [_kMovie];

void main() {
  late _MockPopularMoviesRepository mockRepository;
  late GetPopularMoviesUseCase useCase;

  setUp(() {
    mockRepository = _MockPopularMoviesRepository();
    useCase = GetPopularMoviesUseCase(mockRepository);
  });

  group('GetPopularMoviesUseCase', () {
    test('delegates to repository with isOnline=true', () async {
      // Arrange
      when(
        () => mockRepository.getPopularMovies(isOnline: true),
      ).thenAnswer((_) async => Right(_kMovieList));

      // Act
      final result = await useCase(const OnlineParams(isOnline: true));

      // Assert
      result.fold((_) => fail('expected Right'), (movies) {
        expect(movies, equals(_kMovieList));
      });
      verify(() => mockRepository.getPopularMovies(isOnline: true)).called(1);
    });

    test('delegates to repository with isOnline=false', () async {
      // Arrange
      when(
        () => mockRepository.getPopularMovies(isOnline: false),
      ).thenAnswer((_) async => Right(_kMovieList));

      // Act
      final result = await useCase(const OnlineParams(isOnline: false));

      // Assert
      result.fold((_) => fail('expected Right'), (movies) {
        expect(movies, equals(_kMovieList));
      });
    });

    test('returns Left(Failure) when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.getPopularMovies(isOnline: true),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(const OnlineParams(isOnline: true));

      // Assert
      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });
}
