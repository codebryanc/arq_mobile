import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movies_by_category/domain/repositories/movies_by_category_repository.dart';
import 'package:arq_mobile/features/movies_by_category/domain/usecases/get_movies_by_category_usecase.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

class _MockMoviesByCategoryRepository extends Mock
    implements MoviesByCategoryRepository {}

// Test constants
const _kCategoryId = 28;
const _kPage = 1;
const _kTotalPages = 5;
const _kMovieId = 550;

final _kMovie = MovieModel(
  id: _kMovieId,
  title: 'Fight Club',
  overview: '',
  posterPath: '/poster.jpg',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
);

void main() {
  late _MockMoviesByCategoryRepository mockRepository;
  late GetMoviesByCategoryUseCase useCase;

  setUp(() {
    mockRepository = _MockMoviesByCategoryRepository();
    useCase = GetMoviesByCategoryUseCase(mockRepository);
  });

  group('GetMoviesByCategoryUseCase', () {
    test('delegates online request to repository', () async {
      // Arrange
      when(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        ),
      ).thenAnswer((_) async => Right(([_kMovie], _kTotalPages)));

      // Act
      final result = await useCase(
        const CategoryParams(categoryId: _kCategoryId, isOnline: true),
      );

      // Assert
      result.fold((_) => fail('expected Right'), (record) {
        final (movies, totalPages) = record;
        expect(movies.first.id, equals(_kMovieId));
        expect(totalPages, equals(_kTotalPages));
      });
      verify(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        ),
      ).called(1);
    });

    test('delegates offline request to repository', () async {
      // Arrange
      when(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: false,
        ),
      ).thenAnswer((_) async => Right(([_kMovie], _kTotalPages)));

      // Act
      final result = await useCase(
        const CategoryParams(categoryId: _kCategoryId, isOnline: false),
      );

      // Assert
      result.fold((_) => fail('expected Right'), (record) {
        final (movies, _) = record;
        expect(movies, hasLength(1));
      });
    });

    test('uses custom page when provided', () async {
      // Arrange
      const customPage = 3;
      when(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          customPage,
          isOnline: true,
        ),
      ).thenAnswer((_) async => Right((<Movie>[], _kTotalPages)));

      // Act
      final result = await useCase(
        const CategoryParams(
          categoryId: _kCategoryId,
          isOnline: true,
          page: customPage,
        ),
      );

      // Assert
      result.fold((_) => fail('expected Right'), (_) {});
      verify(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          customPage,
          isOnline: true,
        ),
      ).called(1);
    });

    test('returns Left(Failure) when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.getMoviesByCategory(
          _kCategoryId,
          _kPage,
          isOnline: true,
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(
        const CategoryParams(categoryId: _kCategoryId, isOnline: true),
      );

      // Assert
      expect(result, isA<Left<Failure, (List<Movie>, int)>>());
    });
  });
}
