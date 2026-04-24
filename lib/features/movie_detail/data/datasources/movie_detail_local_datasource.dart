import 'dart:convert';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/movie_detail/data/models/actor_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_detail_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_image_model.dart';

abstract class MovieDetailLocalDataSource {
  Future<MovieDetailModel> getMovieDetail(int movieId);
  Future<List<ActorModel>> getMovieCast(int movieId);
  Future<List<MovieImageModel>> getMovieImages(int movieId);
}

class MovieDetailLocalDataSourceImpl implements MovieDetailLocalDataSource {
  // [Properties]
  static const String _endpoint = '/movie';
  static const String _methodCredits = 'credits';
  static const String _methodImages = 'images';

  // [Methods]
  @override
  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final content = await loadMockAsset(
      FeaturesConfig.movieDetail,
      '$_endpoint/$movieId',
    );
    if (content == null)
      throw ServerException(message: 'No mock for movie $movieId');
    return MovieDetailModel.fromJson(
      jsonDecode(content) as Map<String, dynamic>,
    );
  }

  @override
  Future<List<ActorModel>> getMovieCast(int movieId) async {
    final content = await loadMockAsset(
      FeaturesConfig.movieDetail,
      '$_endpoint/$movieId/$_methodCredits',
    );
    if (content == null) return [];
    final data = jsonDecode(content) as Map<String, dynamic>;
    final cast = data['cast'] as List<dynamic>;
    return cast
        .where((e) => (e as Map<String, dynamic>)['profile_path'] != null)
        .take(20)
        .map((e) => ActorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MovieImageModel>> getMovieImages(int movieId) async {
    final content = await loadMockAsset(
      FeaturesConfig.movieDetail,
      '$_endpoint/$movieId/$_methodImages',
    );
    if (content == null) return [];
    final data = jsonDecode(content) as Map<String, dynamic>;
    final backdrops = data['backdrops'] as List<dynamic>;
    return backdrops
        .take(10)
        .map((e) => MovieImageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
