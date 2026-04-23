import 'dart:async';

import 'package:dio/dio.dart';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/popular_movies/data/models/movie_model.dart';

abstract class PopularMoviesRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies();
}

class PopularMoviesRemoteDataSourceImpl
    implements PopularMoviesRemoteDataSource {
  // [Properties]
  final Dio dio;
  static const String _endpoint = '/movie/popular';

  // [Constructor]
  const PopularMoviesRemoteDataSourceImpl({required this.dio});

  // [Methods]
  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await dio.get(_endpoint);

      // To save local data
      if(FeaturesConfig.recordSession) {
        unawaited(saveMock(FeaturesConfig.popularMovies, '${endpointToFileName(_endpoint)}.json', response.data));
      }

      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => e as Map<String, dynamic>)
          .where(
            (e) =>
                e['poster_path'] != null &&
                (e['poster_path'] as String).isNotEmpty,
          )
          .map(MovieModel.fromJson)
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }
}
