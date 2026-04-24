import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_cast_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_images_usecase.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_event.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_state.dart';

class _MockGetMovieDetailUseCase extends Mock
    implements GetMovieDetailUseCase {}

class _MockGetMovieCastUseCase extends Mock implements GetMovieCastUseCase {}

class _MockGetMovieImagesUseCase extends Mock
    implements GetMovieImagesUseCase {}

// Test constants
const _kMovieId = 550;
const _kActorId = 819;

final _kMovieDetail = MovieDetail(
  id: _kMovieId,
  title: 'Fight Club',
  overview: '',
  voteAverage: 8.4,
  posterPath: '/poster.jpg',
  backdropPath: '/backdrop.jpg',
  releaseDate: '1999-10-15',
  runtime: 139,
  genres: ['Drama'],
);

final _kActor = Actor(
  id: _kActorId,
  name: 'Edward Norton',
  character: 'The Narrator',
  profilePath: '/profile.jpg',
);

final _kImage = MovieImage(filePath: '/backdrop.jpg');

void main() {
  late _MockGetMovieDetailUseCase mockDetail;
  late _MockGetMovieCastUseCase mockCast;
  late _MockGetMovieImagesUseCase mockImages;

  setUpAll(() {
    registerFallbackValue(
      const MovieDetailParams(movieId: _kMovieId, isOnline: true),
    );
  });

  setUp(() {
    mockDetail = _MockGetMovieDetailUseCase();
    mockCast = _MockGetMovieCastUseCase();
    mockImages = _MockGetMovieImagesUseCase();
  });

  MovieDetailBloc buildBloc() => MovieDetailBloc(
    getMovieDetail: mockDetail,
    getMovieCast: mockCast,
    getMovieImages: mockImages,
  );

  group('MovieDetailBloc', () {
    test('initial state is MovieDetailInitial', () {
      // Arrange & Act
      final bloc = buildBloc();

      // Assert
      expect(bloc.state, isA<MovieDetailInitial>());
      bloc.close();
    });

    group('LoadMovieDetail', () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits [Loading, Loaded] when all requests succeed',
        build: buildBloc,
        setUp: () {
          when(
            () => mockDetail(any()),
          ).thenAnswer((_) async => Right(_kMovieDetail));
          when(() => mockCast(any())).thenAnswer((_) async => Right([_kActor]));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => Right([_kImage]));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        expect: () => [isA<MovieDetailLoading>(), isA<MovieDetailLoaded>()],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'loaded state contains detail, cast and images',
        build: buildBloc,
        setUp: () {
          when(
            () => mockDetail(any()),
          ).thenAnswer((_) async => Right(_kMovieDetail));
          when(() => mockCast(any())).thenAnswer((_) async => Right([_kActor]));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => Right([_kImage]));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        verify: (bloc) {
          final loaded = bloc.state as MovieDetailLoaded;
          expect(loaded.detail.id, equals(_kMovieId));
          expect(loaded.cast, hasLength(1));
          expect(loaded.images, hasLength(1));
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits [Loading, Error] when detail request fails',
        build: buildBloc,
        setUp: () {
          when(
            () => mockDetail(any()),
          ).thenAnswer((_) async => const Left(NotFoundFailure()));
          when(() => mockCast(any())).thenAnswer((_) async => Right([_kActor]));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => Right([_kImage]));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        expect: () => [isA<MovieDetailLoading>(), isA<MovieDetailError>()],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'loaded state degrades cast to empty list when cast fails',
        build: buildBloc,
        setUp: () {
          when(
            () => mockDetail(any()),
          ).thenAnswer((_) async => Right(_kMovieDetail));
          when(
            () => mockCast(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => Right([_kImage]));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        verify: (bloc) {
          final loaded = bloc.state as MovieDetailLoaded;
          expect(loaded.cast, isEmpty);
          expect(loaded.images, hasLength(1));
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'loaded state degrades images to empty list when images fail',
        build: buildBloc,
        setUp: () {
          when(
            () => mockDetail(any()),
          ).thenAnswer((_) async => Right(_kMovieDetail));
          when(() => mockCast(any())).thenAnswer((_) async => Right([_kActor]));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        verify: (bloc) {
          final loaded = bloc.state as MovieDetailLoaded;
          expect(loaded.cast, hasLength(1));
          expect(loaded.images, isEmpty);
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'emits [Loading, Error(NotFoundFailure)] when a use case throws',
        build: buildBloc,
        setUp: () {
          when(() => mockDetail(any())).thenThrow(Exception('parallel error'));
          when(() => mockCast(any())).thenAnswer((_) async => Right([_kActor]));
          when(
            () => mockImages(any()),
          ).thenAnswer((_) async => Right([_kImage]));
        },
        act: (bloc) =>
            bloc.add(const LoadMovieDetail(movieId: _kMovieId, isOnline: true)),
        expect: () => [isA<MovieDetailLoading>(), isA<MovieDetailError>()],
        verify: (bloc) {
          final error = bloc.state as MovieDetailError;
          expect(error.failure, isA<NotFoundFailure>());
        },
      );
    });
  });
}
