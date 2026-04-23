sealed class MovieDetailEvent {
  const MovieDetailEvent();
}

final class LoadMovieDetail extends MovieDetailEvent {
  // [Constructor]
  const LoadMovieDetail({required this.movieId, required this.isOnline});

  // [Properties]
  final int movieId;
  final bool isOnline;
}
