import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_cast_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_images_usecase.dart';

class _MockMovieDetailRepository extends Mock implements MovieDetailRepository {}

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

final _kImage = MovieImage(filePath: '/image.jpg');

final _kParams = MovieDetailParams(movieId: _kMovieId, isOnline: true);
final _kParamsOffline = MovieDetailParams(movieId: _kMovieId, isOnline: false);

void main() {
  late _MockMovieDetailRepository mockRepository;

  setUp(() {
    mockRepository = _MockMovieDetailRepository();
  });

  // ── GetMovieDetailUseCase ───────────────────────────────────────

  group('GetMovieDetailUseCase', () {
    late GetMovieDetailUseCase useCase;

    setUp(() => useCase = GetMovieDetailUseCase(mockRepository));

    test('delegates to repository online', () async {
      // Arrange
      when(() => mockRepository.getMovieDetail(_kMovieId, isOnline: true))
          .thenAnswer((_) async => Right(_kMovieDetail));

      // Act
      final result = await useCase(_kParams);

      // Assert
      result.fold((_) => fail('expected Right'), (d) {
        expect(d.id, equals(_kMovieId));
      });
      verify(
        () => mockRepository.getMovieDetail(_kMovieId, isOnline: true),
      ).called(1);
    });

    test('delegates to repository offline', () async {
      // Arrange
      when(() => mockRepository.getMovieDetail(_kMovieId, isOnline: false))
          .thenAnswer((_) async => Right(_kMovieDetail));

      // Act
      final result = await useCase(_kParamsOffline);

      // Assert
      result.fold((_) => fail('expected Right'), (d) {
        expect(d.id, equals(_kMovieId));
      });
    });

    test('propagates Left(Failure) from repository', () async {
      // Arrange
      when(() => mockRepository.getMovieDetail(_kMovieId, isOnline: true))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(_kParams);

      // Assert
      expect(result, isA<Left<Failure, MovieDetail>>());
    });
  });

  // ── GetMovieCastUseCase ─────────────────────────────────────────

  group('GetMovieCastUseCase', () {
    late GetMovieCastUseCase useCase;

    setUp(() => useCase = GetMovieCastUseCase(mockRepository));

    test('delegates to repository online', () async {
      // Arrange
      when(() => mockRepository.getMovieCast(_kMovieId, isOnline: true))
          .thenAnswer((_) async => Right([_kActor]));

      // Act
      final result = await useCase(_kParams);

      // Assert
      result.fold((_) => fail('expected Right'), (cast) {
        expect(cast.first.id, equals(_kActorId));
      });
    });

    test('delegates to repository offline', () async {
      // Arrange
      when(() => mockRepository.getMovieCast(_kMovieId, isOnline: false))
          .thenAnswer((_) async => Right([_kActor]));

      // Act
      final result = await useCase(_kParamsOffline);

      // Assert
      result.fold((_) => fail('expected Right'), (cast) {
        expect(cast, hasLength(1));
      });
    });

    test('propagates Left(Failure) from repository', () async {
      // Arrange
      when(() => mockRepository.getMovieCast(_kMovieId, isOnline: true))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(_kParams);

      // Assert
      expect(result, isA<Left<Failure, List<Actor>>>());
    });
  });

  // ── GetMovieImagesUseCase ───────────────────────────────────────

  group('GetMovieImagesUseCase', () {
    late GetMovieImagesUseCase useCase;

    setUp(() => useCase = GetMovieImagesUseCase(mockRepository));

    test('delegates to repository online', () async {
      // Arrange
      when(() => mockRepository.getMovieImages(_kMovieId, isOnline: true))
          .thenAnswer((_) async => Right([_kImage]));

      // Act
      final result = await useCase(_kParams);

      // Assert
      result.fold((_) => fail('expected Right'), (images) {
        expect(images.first.filePath, equals(_kImage.filePath));
      });
    });

    test('delegates to repository offline', () async {
      // Arrange
      when(() => mockRepository.getMovieImages(_kMovieId, isOnline: false))
          .thenAnswer((_) async => Right([_kImage]));

      // Act
      final result = await useCase(_kParamsOffline);

      // Assert
      result.fold((_) => fail('expected Right'), (images) {
        expect(images, hasLength(1));
      });
    });

    test('propagates Left(Failure) from repository', () async {
      // Arrange
      when(() => mockRepository.getMovieImages(_kMovieId, isOnline: true))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(_kParams);

      // Assert
      expect(result, isA<Left<Failure, List<MovieImage>>>());
    });
  });
}
