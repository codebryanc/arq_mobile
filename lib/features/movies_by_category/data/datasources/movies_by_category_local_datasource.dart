import 'dart:convert';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

abstract class MoviesByCategoryLocalDataSource {
  Future<({List<MovieModel> movies, int totalPages})> getMoviesByCategory(
    int categoryId,
    int page,
  );
}

class MoviesByCategoryLocalDataSourceImpl
    implements MoviesByCategoryLocalDataSource {
  // [Properties]
  static const String _endpoint = '/discover/movie';

  // [Methods]
  @override
  Future<({List<MovieModel> movies, int totalPages})> getMoviesByCategory(
    int categoryId,
    int page,
  ) async {
    final content = await loadMockAsset(
      FeaturesConfig.moviesByCategory,
      _endpoint,
      '_${categoryId}_$page',
    );
    if (content == null) return (movies: <MovieModel>[], totalPages: 0);
    final data = jsonDecode(content) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return (
      movies: results
          .map((e) => e as Map<String, dynamic>)
          .where(
            (e) =>
                e['poster_path'] != null &&
                (e['poster_path'] as String).isNotEmpty,
          )
          .map(MovieModel.fromJson)
          .toList(),
      totalPages: data['total_pages'] as int,
    );
  }
}
