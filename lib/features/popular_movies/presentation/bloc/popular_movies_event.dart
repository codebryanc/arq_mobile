sealed class PopularMoviesEvent {
  const PopularMoviesEvent();
}

final class LoadPopularMovies extends PopularMoviesEvent {
  const LoadPopularMovies({required this.isOnline});

  final bool isOnline;
}
