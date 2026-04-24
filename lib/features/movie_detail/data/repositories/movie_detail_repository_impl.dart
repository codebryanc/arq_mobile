import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_local_datasource.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  // [Properties]
  final MovieDetailRemoteDataSource remoteDataSource;
  final MovieDetailLocalDataSource localDataSource;

  // [Constructor]
  const MovieDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // [Methods]
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(
    int movieId, {
    required bool isOnline,
  }) async {
    if (!isOnline) {
      try {
        return Right(await localDataSource.getMovieDetail(movieId));
      } catch (_) {
        return Left(const NotFoundFailure());
      }
    }

    try {
      return Right(await remoteDataSource.getMovieDetail(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> getMovieCast(
    int movieId, {
    required bool isOnline,
  }) async {
    if (!isOnline) {
      return Right(await localDataSource.getMovieCast(movieId));
    }

    try {
      return Right(await remoteDataSource.getMovieCast(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<MovieImage>>> getMovieImages(
    int movieId, {
    required bool isOnline,
  }) async {
    if (!isOnline) {
      return Right(await localDataSource.getMovieImages(movieId));
    }

    try {
      return Right(await remoteDataSource.getMovieImages(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
