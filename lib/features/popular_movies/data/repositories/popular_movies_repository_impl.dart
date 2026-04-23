import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_local_datasource.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_remote_datasource.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';
import 'package:arq_mobile/features/popular_movies/domain/repositories/popular_movies_repository.dart';

class PopularMoviesRepositoryImpl implements PopularMoviesRepository {
  // [Properties]
  final PopularMoviesRemoteDataSource remoteDataSource;
  final PopularMoviesLocalDataSource localDataSource;

  // [Constructor]
  const PopularMoviesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // [Methods]
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    required bool isOnline,
  }) async {
    if (!isOnline) return Right(await localDataSource.getPopularMovies());

    try {
      final movies = await remoteDataSource.getPopularMovies();
      return Right(movies);
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
