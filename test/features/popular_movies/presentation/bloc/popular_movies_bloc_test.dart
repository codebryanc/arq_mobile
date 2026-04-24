import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';
import 'package:arq_mobile/features/popular_movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_event.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_state.dart';

class _MockGetPopularMoviesUseCase extends Mock
    implements GetPopularMoviesUseCase {}

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
  late _MockGetPopularMoviesUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const OnlineParams(isOnline: true));
  });

  setUp(() {
    mockUseCase = _MockGetPopularMoviesUseCase();
  });

  PopularMoviesBloc buildBloc() =>
      PopularMoviesBloc(getPopularMovies: mockUseCase);

  group('PopularMoviesBloc', () {
    test('initial state is PopularMoviesInitial', () {
      // Arrange & Act
      final bloc = buildBloc();

      // Assert
      expect(bloc.state, isA<PopularMoviesInitial>());
      bloc.close();
    });

    group('LoadPopularMovies', () {
      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'emits [Loading, Loaded] on success',
        build: buildBloc,
        setUp: () {
          when(() => mockUseCase(any()))
              .thenAnswer((_) async => Right(_kMovieList));
        },
        act: (bloc) => bloc.add(const LoadPopularMovies(isOnline: true)),
        expect: () => [
          isA<PopularMoviesLoading>(),
          isA<PopularMoviesLoaded>(),
        ],
      );

      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'loaded state contains the movies list',
        build: buildBloc,
        setUp: () {
          when(() => mockUseCase(any()))
              .thenAnswer((_) async => Right(_kMovieList));
        },
        act: (bloc) => bloc.add(const LoadPopularMovies(isOnline: true)),
        verify: (bloc) {
          final loaded = bloc.state as PopularMoviesLoaded;
          expect(loaded.movies, equals(_kMovieList));
        },
      );

      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'emits [Loading, Error] on failure',
        build: buildBloc,
        setUp: () {
          when(() => mockUseCase(any()))
              .thenAnswer((_) async => const Left(NetworkFailure()));
        },
        act: (bloc) => bloc.add(const LoadPopularMovies(isOnline: false)),
        expect: () => [
          isA<PopularMoviesLoading>(),
          isA<PopularMoviesError>(),
        ],
      );

      blocTest<PopularMoviesBloc, PopularMoviesState>(
        'error state holds the failure',
        build: buildBloc,
        setUp: () {
          when(() => mockUseCase(any()))
              .thenAnswer((_) async => const Left(NetworkFailure()));
        },
        act: (bloc) => bloc.add(const LoadPopularMovies(isOnline: true)),
        verify: (bloc) {
          final error = bloc.state as PopularMoviesError;
          expect(error.failure, isA<NetworkFailure>());
        },
      );
    });
  });
}
