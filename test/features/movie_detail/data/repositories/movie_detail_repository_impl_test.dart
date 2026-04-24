import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_local_datasource.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:arq_mobile/features/movie_detail/data/models/actor_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_detail_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_image_model.dart';
import 'package:arq_mobile/features/movie_detail/data/repositories/movie_detail_repository_impl.dart';

class _MockRemote extends Mock implements MovieDetailRemoteDataSource {}

class _MockLocal extends Mock implements MovieDetailLocalDataSource {}

// Test constants
const _kMovieId = 550;
const _kActorId = 819;
const _kActorName = 'Edward Norton';
const _kErrorMessage = 'Not found';
const _kStatusCode = 404;

final _kMovieDetail = MovieDetailModel(
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

final _kActor = ActorModel(
  id: _kActorId,
  name: _kActorName,
  character: 'The Narrator',
  profilePath: '/profile.jpg',
);

final _kImage = MovieImageModel(filePath: '/image.jpg');

void main() {
  late _MockRemote mockRemote;
  late _MockLocal mockLocal;
  late MovieDetailRepositoryImpl repository;

  setUp(() {
    mockRemote = _MockRemote();
    mockLocal = _MockLocal();
    repository = MovieDetailRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('MovieDetailRepositoryImpl', () {
    // ── getMovieDetail ──────────────────────────────────────────────

    group('getMovieDetail — offline', () {
      test('returns Right with local data when offline', () async {
        // Arrange
        when(() => mockLocal.getMovieDetail(_kMovieId))
            .thenAnswer((_) async => _kMovieDetail);

        // Act
        final result = await repository.getMovieDetail(
          _kMovieId,
          isOnline: false,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (d) {
          expect(d.id, equals(_kMovieId));
        });
        verifyNever(() => mockRemote.getMovieDetail(any()));
      });

      test('returns Left(NotFoundFailure) when local throws', () async {
        // Arrange
        when(() => mockLocal.getMovieDetail(_kMovieId))
            .thenThrow(ServerException(message: _kErrorMessage));

        // Act
        final result = await repository.getMovieDetail(
          _kMovieId,
          isOnline: false,
        );

        // Assert
        result.fold(
          (f) => expect(f, isA<NotFoundFailure>()),
          (_) => fail('expected Left'),
        );
      });
    });

    group('getMovieDetail — online', () {
      test('returns Right with remote data on success', () async {
        // Arrange
        when(() => mockRemote.getMovieDetail(_kMovieId))
            .thenAnswer((_) async => _kMovieDetail);

        // Act
        final result = await repository.getMovieDetail(
          _kMovieId,
          isOnline: true,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (d) {
          expect(d.id, equals(_kMovieId));
        });
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        // Arrange
        when(() => mockRemote.getMovieDetail(_kMovieId))
            .thenThrow(const NetworkException());

        // Act
        final result = await repository.getMovieDetail(
          _kMovieId,
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
        when(() => mockRemote.getMovieDetail(_kMovieId)).thenThrow(
          ServerException(message: _kErrorMessage, statusCode: _kStatusCode),
        );

        // Act
        final result = await repository.getMovieDetail(
          _kMovieId,
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

    // ── getMovieCast ────────────────────────────────────────────────

    group('getMovieCast — offline', () {
      test('returns Right with local cast when offline', () async {
        // Arrange
        when(() => mockLocal.getMovieCast(_kMovieId))
            .thenAnswer((_) async => [_kActor]);

        // Act
        final result = await repository.getMovieCast(
          _kMovieId,
          isOnline: false,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (cast) {
          expect(cast, hasLength(1));
        });
        verifyNever(() => mockRemote.getMovieCast(any()));
      });
    });

    group('getMovieCast — online', () {
      test('returns Right with remote cast on success', () async {
        // Arrange
        when(() => mockRemote.getMovieCast(_kMovieId))
            .thenAnswer((_) async => [_kActor]);

        // Act
        final result = await repository.getMovieCast(
          _kMovieId,
          isOnline: true,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (cast) {
          expect(cast.first.id, equals(_kActorId));
        });
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        // Arrange
        when(() => mockRemote.getMovieCast(_kMovieId))
            .thenThrow(const NetworkException());

        // Act
        final result = await repository.getMovieCast(
          _kMovieId,
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
        when(() => mockRemote.getMovieCast(_kMovieId)).thenThrow(
          ServerException(message: _kErrorMessage),
        );

        // Act
        final result = await repository.getMovieCast(
          _kMovieId,
          isOnline: true,
        );

        // Assert
        result.fold(
          (f) => expect(f, isA<ServerFailure>()),
          (_) => fail('expected Left'),
        );
      });
    });

    // ── getMovieImages ──────────────────────────────────────────────

    group('getMovieImages — offline', () {
      test('returns Right with local images when offline', () async {
        // Arrange
        when(() => mockLocal.getMovieImages(_kMovieId))
            .thenAnswer((_) async => [_kImage]);

        // Act
        final result = await repository.getMovieImages(
          _kMovieId,
          isOnline: false,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (images) {
          expect(images, hasLength(1));
        });
        verifyNever(() => mockRemote.getMovieImages(any()));
      });
    });

    group('getMovieImages — online', () {
      test('returns Right with remote images on success', () async {
        // Arrange
        when(() => mockRemote.getMovieImages(_kMovieId))
            .thenAnswer((_) async => [_kImage]);

        // Act
        final result = await repository.getMovieImages(
          _kMovieId,
          isOnline: true,
        );

        // Assert
        result.fold((_) => fail('expected Right'), (images) {
          expect(images.first.filePath, equals(_kImage.filePath));
        });
      });

      test('returns Left(NetworkFailure) on NetworkException', () async {
        // Arrange
        when(() => mockRemote.getMovieImages(_kMovieId))
            .thenThrow(const NetworkException());

        // Act
        final result = await repository.getMovieImages(
          _kMovieId,
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
        when(() => mockRemote.getMovieImages(_kMovieId)).thenThrow(
          ServerException(message: _kErrorMessage),
        );

        // Act
        final result = await repository.getMovieImages(
          _kMovieId,
          isOnline: true,
        );

        // Assert
        result.fold(
          (f) => expect(f, isA<ServerFailure>()),
          (_) => fail('expected Left'),
        );
      });
    });
  });
}
