import 'dart:async';

import 'package:dio/dio.dart';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

abstract class MoviesByCategoryRemoteDataSource {
  Future<({List<MovieModel> movies, int totalPages})> getMoviesByCategory(
    int categoryId,
    int page,
  );
}

class MoviesByCategoryRemoteDataSourceImpl
    implements MoviesByCategoryRemoteDataSource {
  // [Properties]
  final Dio dio;
  static const String _endpoint = '/discover/movie';

  // [Constructor]
  const MoviesByCategoryRemoteDataSourceImpl({required this.dio});

  // [Methods]
  @override
  Future<({List<MovieModel> movies, int totalPages})> getMoviesByCategory(
    int categoryId,
    int page,
  ) async {
    try {
      final endpoint = _endpoint;
      final response = await dio.get(
        endpoint,
        queryParameters: {'with_genres': categoryId, 'page': page},
      );

      // To save local data
      if (FeaturesConfig.recordSession) {
        unawaited(
          saveMock(
            FeaturesConfig.moviesByCategory,
            '${endpointToFileName(endpoint)}_${categoryId}_$page.json',
            response.data,
          ),
        );
      }

      final data = response.data as Map<String, dynamic>;
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
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }
}
