import 'dart:async';

import 'package:dio/dio.dart';

import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/category/data/models/category_model.dart';
import 'package:arq_mobile/core/config/features_config.dart';

/// BEGIN: LISKOV SUBSTITUTION PRINCIPLE (SOLID) ///
///
/// Both CategoryRemoteDataSource and CategoryLocalDataSource share the same contract.
/// The repository can swap between them based on connectivity without breaking behavior.
///
/// END: LISKOV SUBSTITUTION PRINCIPLE ///
abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  // [Properties]
  final Dio dio;
  static const String _endpoint = '/genre/movie/list';

  // [Constructor]
  const CategoryRemoteDataSourceImpl({required this.dio});

  // [Methods]
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(_endpoint);
      final genres = response.data['genres'] as List<dynamic>;

      // To save local data
      if (FeaturesConfig.recordSession) {
        unawaited(
          saveMock(
            FeaturesConfig.category,
            '${endpointToFileName(_endpoint)}.json',
            response.data,
          ),
        );
      }

      return genres
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) throw const NetworkException();
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? '');
    }
  }
}
