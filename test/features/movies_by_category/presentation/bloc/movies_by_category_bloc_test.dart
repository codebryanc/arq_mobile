import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movies_by_category/domain/usecases/get_movies_by_category_usecase.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_state.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

class _MockGetMoviesByCategoryUseCase extends Mock
    implements GetMoviesByCategoryUseCase {}

// Test constants
const _kCategoryId = 28;
const _kPage1 = 1;
const _kPage2 = 2;
const _kTotalPages = 5;
const _kMovieId = 550;
const _kMovieId2 = 551;

final _kMovie = MovieModel(
  id: _kMovieId,
  title: 'Fight Club',
  overview: '',
  posterPath: '/poster.jpg',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
);

final _kMovie2 = MovieModel(
  id: _kMovieId2,
  title: 'Pulp Fiction',
  overview: '',
  posterPath: '/poster2.jpg',
  voteAverage: 8.9,
  releaseDate: '1994-10-14',
);

void main() {
  late _MockGetMoviesByCategoryUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(
      const CategoryParams(categoryId: _kCategoryId, isOnline: true),
    );
  });

  setUp(() {
    mockUseCase = _MockGetMoviesByCategoryUseCase();
  });

  MoviesByCategoryBloc buildBloc() =>
      MoviesByCategoryBloc(getMoviesByCategory: mockUseCase);

  group('MoviesByCategoryBloc', () {
    test('initial state is MoviesByCategoryInitial', () {
      // Arrange & Act
      final bloc = buildBloc();

      // Assert
      expect(bloc.state, isA<MoviesByCategoryInitial>());
      bloc.close();
    });

    group('LoadMoviesByCategory', () {
      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'emits [Loading, Loaded] on success',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(([_kMovie], _kTotalPages)));
        },
        act: (bloc) => bloc.add(
          const LoadMoviesByCategory(categoryId: _kCategoryId, isOnline: true),
        ),
        expect: () => [
          isA<MoviesByCategoryLoading>(),
          isA<MoviesByCategoryLoaded>(),
        ],
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'loaded state contains movies, currentPage and totalPages',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(([_kMovie], _kTotalPages)));
        },
        act: (bloc) => bloc.add(
          const LoadMoviesByCategory(categoryId: _kCategoryId, isOnline: true),
        ),
        verify: (bloc) {
          final loaded = bloc.state as MoviesByCategoryLoaded;
          expect(loaded.movies, hasLength(1));
          expect(loaded.currentPage, equals(_kPage1));
          expect(loaded.totalPages, equals(_kTotalPages));
        },
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'emits [Loading, Error] on failure',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        act: (bloc) => bloc.add(
          const LoadMoviesByCategory(categoryId: _kCategoryId, isOnline: false),
        ),
        expect: () => [
          isA<MoviesByCategoryLoading>(),
          isA<MoviesByCategoryError>(),
        ],
      );
    });

    group('LoadMoreMoviesByCategory', () {
      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'does nothing when state is not Loaded',
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadMoreMoviesByCategory()),
        expect: () => [],
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'does nothing when there are no more pages',
        build: buildBloc,
        seed: () => MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kTotalPages,
          totalPages: _kTotalPages,
        ),
        act: (bloc) => bloc.add(const LoadMoreMoviesByCategory()),
        expect: () => [],
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'does nothing when already loading more',
        build: buildBloc,
        seed: () => MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kPage1,
          totalPages: _kTotalPages,
          isLoadingMore: true,
        ),
        act: (bloc) => bloc.add(const LoadMoreMoviesByCategory()),
        expect: () => [],
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'appends movies on success',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(([_kMovie2], _kTotalPages)));
        },
        seed: () => MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kPage1,
          totalPages: _kTotalPages,
        ),
        act: (bloc) {
          // Simulate prior LoadMoviesByCategory to set _currentCategoryId
          bloc
            ..add(
              LoadMoviesByCategory(
                categoryId: _kCategoryId,
                isOnline: true,
                page: _kPage1,
              ),
            )
            ..add(const LoadMoreMoviesByCategory());
        },
        // States: loading, loaded (p1), loading-more, loaded (p1+p2)
        expect: () => [
          isA<MoviesByCategoryLoading>(),
          isA<MoviesByCategoryLoaded>(),
          isA<MoviesByCategoryLoaded>(), // isLoadingMore: true
          isA<MoviesByCategoryLoaded>(), // appended
        ],
        verify: (bloc) {
          final loaded = bloc.state as MoviesByCategoryLoaded;
          expect(loaded.currentPage, equals(_kPage2));
          expect(loaded.movies.length, greaterThan(1));
        },
      );

      blocTest<MoviesByCategoryBloc, MoviesByCategoryState>(
        'keeps existing movies and stops loading more on failure',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        seed: () => MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kPage1,
          totalPages: _kTotalPages,
        ),
        act: (bloc) {
          bloc
            ..add(
              LoadMoviesByCategory(
                categoryId: _kCategoryId,
                isOnline: true,
                page: _kPage1,
              ),
            )
            ..add(const LoadMoreMoviesByCategory());
        },
        verify: (bloc) {
          if (bloc.state is MoviesByCategoryLoaded) {
            expect(
              (bloc.state as MoviesByCategoryLoaded).isLoadingMore,
              isFalse,
            );
          }
        },
      );
    });

    group('MoviesByCategoryLoaded.copyWith', () {
      test('creates a copy with updated fields', () {
        // Arrange
        final original = MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kPage1,
          totalPages: _kTotalPages,
        );

        // Act
        final copy = original.copyWith(
          movies: [_kMovie, _kMovie2],
          currentPage: _kPage2,
          isLoadingMore: true,
        );

        // Assert
        expect(copy.movies, hasLength(2));
        expect(copy.currentPage, equals(_kPage2));
        expect(copy.totalPages, equals(_kTotalPages));
        expect(copy.isLoadingMore, isTrue);
      });

      test('hasMore returns true when currentPage < totalPages', () {
        // Arrange & Act
        final state = MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kPage1,
          totalPages: _kTotalPages,
        );

        // Assert
        expect(state.hasMore, isTrue);
      });

      test('hasMore returns false when currentPage equals totalPages', () {
        // Arrange & Act
        final state = MoviesByCategoryLoaded(
          [_kMovie],
          currentPage: _kTotalPages,
          totalPages: _kTotalPages,
        );

        // Assert
        expect(state.hasMore, isFalse);
      });
    });
  });
}
