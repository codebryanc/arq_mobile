import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

abstract class PopularMoviesRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();
}
