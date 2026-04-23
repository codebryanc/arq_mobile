import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

abstract class PopularMoviesLocalDataSource {
  Future<List<MovieModel>> getPopularMovies();
}

class PopularMoviesLocalDataSourceImpl implements PopularMoviesLocalDataSource {
  // [Methods]
  @override
  Future<List<MovieModel>> getPopularMovies() async => [];
}