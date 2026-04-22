import 'package:dio/dio.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';

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
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }
}
