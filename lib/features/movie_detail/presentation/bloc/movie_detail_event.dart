sealed class MovieDetailEvent {
  const MovieDetailEvent();
}

final class LoadMovieDetail extends MovieDetailEvent {
  // [Constructor]
  const LoadMovieDetail({required this.movieId});

  // [Properties]
  final int movieId;
}
