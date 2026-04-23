import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_remote_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/domain/repositories/movies_by_category_repository.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

class MoviesByCategoryRepositoryImpl implements MoviesByCategoryRepository {
  // [Properties]
  final MoviesByCategoryRemoteDataSource remoteDataSource;

  // [Constructor]
  const MoviesByCategoryRepositoryImpl({required this.remoteDataSource});

  // [Methods]
  @override
  Future<Either<Failure, (List<Movie>, int)>> getMoviesByCategory(
    int categoryId,
    int page, {
    required bool isOnline,
  }) async {
    if (!isOnline) return const Right(([], 0));

    try {
      final result = await remoteDataSource.getMoviesByCategory(
        categoryId,
        page,
      );
      return Right((result.movies, result.totalPages));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
