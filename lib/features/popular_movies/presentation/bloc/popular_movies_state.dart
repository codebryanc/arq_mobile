import 'package:arq_mobile/core/errors/failures.dart';

import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

sealed class PopularMoviesState {
  const PopularMoviesState();
}

final class PopularMoviesInitial extends PopularMoviesState {
  const PopularMoviesInitial();
}

final class PopularMoviesLoading extends PopularMoviesState {
  const PopularMoviesLoading();
}

final class PopularMoviesLoaded extends PopularMoviesState {
  // [Constructor]
  const PopularMoviesLoaded(this.movies);

  // [Properties]
  final List<Movie> movies;
}

final class PopularMoviesError extends PopularMoviesState {
  // [Constructor]
  const PopularMoviesError(this.failure);

  // [Properties]
  final Failure failure;
}
