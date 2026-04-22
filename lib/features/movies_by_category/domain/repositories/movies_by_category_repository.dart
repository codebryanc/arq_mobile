import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

abstract class MoviesByCategoryRepository {
  Future<Either<Failure, (List<Movie>, int totalPages)>> getMoviesByCategory(
    int categoryId,
    int page,
  );
}
