import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  // [Properties]
  final MovieDetailRemoteDataSource remoteDataSource;

  // [Constructor]
  const MovieDetailRepositoryImpl({required this.remoteDataSource});

  // [Methods]
  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int movieId) async {
    try {
      return Right(await remoteDataSource.getMovieDetail(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> getMovieCast(int movieId) async {
    try {
      return Right(await remoteDataSource.getMovieCast(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<MovieImage>>> getMovieImages(int movieId) async {
    try {
      return Right(await remoteDataSource.getMovieImages(movieId));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
