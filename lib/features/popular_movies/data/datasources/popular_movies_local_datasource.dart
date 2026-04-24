import 'dart:convert';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

abstract class PopularMoviesLocalDataSource {
  Future<List<MovieModel>> getPopularMovies();
}

class PopularMoviesLocalDataSourceImpl implements PopularMoviesLocalDataSource {
  // [Properties]
  static const String _endpoint = '/movie/popular';

  // [Methods]
  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final content = await loadMockAsset(
      FeaturesConfig.popularMovies,
      _endpoint,
    );
    if (content == null) {
      throw ServerException(message: 'No mock for $_endpoint');
    }
    final data = jsonDecode(content) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results
        .map((e) => e as Map<String, dynamic>)
        .where(
          (e) =>
              e['poster_path'] != null &&
              (e['poster_path'] as String).isNotEmpty,
        )
        .map(MovieModel.fromJson)
        .toList();
  }
}
