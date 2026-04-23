import 'dart:async';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:dio/dio.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/features/movie_detail/data/models/actor_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_detail_model.dart';
import 'package:arq_mobile/features/movie_detail/data/models/movie_image_model.dart';

abstract class MovieDetailRemoteDataSource {
  Future<MovieDetailModel> getMovieDetail(int movieId);
  Future<List<ActorModel>> getMovieCast(int movieId);
  Future<List<MovieImageModel>> getMovieImages(int movieId);
}

class MovieDetailRemoteDataSourceImpl implements MovieDetailRemoteDataSource {
  // [Properties]
  final Dio dio;
  static const String _endpoint = '/movie';
  static const String _methodCredits = 'credits';
  static const String _methodImages = 'images';

  // [Constructor]
  const MovieDetailRemoteDataSourceImpl({required this.dio});

  // [Methods]
  @override
  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    try {
      final endpoint = '$_endpoint/$movieId';
      final response = await dio.get(endpoint);

      // To save local data
      if (FeaturesConfig.recordSession) {
        unawaited(
          saveMock(
            FeaturesConfig.movieDetail,
            '${endpointToFileName(endpoint)}.json',
            response.data,
          ),
        );
      }

      return MovieDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }

  @override
  Future<List<ActorModel>> getMovieCast(int movieId) async {
    try {
      final endpoint = '$_endpoint/$movieId/$_methodCredits';
      final response = await dio.get(endpoint);

      // To save local data
      if (FeaturesConfig.recordSession) {
        unawaited(
          saveMock(
            FeaturesConfig.movieDetail,
            '${endpointToFileName(endpoint)}.json',
            response.data,
          ),
        );
      }

      final cast = response.data['cast'] as List<dynamic>;
      return cast
          .where((e) => (e as Map<String, dynamic>)['profile_path'] != null)
          .take(20)
          .map((e) => ActorModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }

  @override
  Future<List<MovieImageModel>> getMovieImages(int movieId) async {
    try {
      final endpoint = '$_endpoint/$movieId/$_methodImages';
      final response = await dio.get(
        endpoint,
        queryParameters: {'include_image_language': 'en,null'},
      );

      // To save local data
      if (FeaturesConfig.recordSession) {
        unawaited(
          saveMock(
            FeaturesConfig.movieDetail,
            '${endpointToFileName(endpoint)}.json',
            response.data,
          ),
        );
      }

      final backdrops = response.data['backdrops'] as List<dynamic>;
      return backdrops
          .take(10)
          .map((e) => MovieImageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }
}
