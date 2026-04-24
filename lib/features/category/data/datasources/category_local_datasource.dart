import 'dart:convert';

import 'package:arq_mobile/core/config/features_config.dart';
import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/utils/mock_saver.dart';
import 'package:arq_mobile/features/category/data/models/category_model.dart';

/// BEGIN: LISKOV SUBSTITUTION PRINCIPLE (SOLID) ///
///
/// Both CategoryRemoteDataSource and CategoryLocalDataSource share the same contract.
/// The repository can swap between them based on connectivity without breaking behavior.
///
/// END: LISKOV SUBSTITUTION PRINCIPLE ///
abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  // [Properties]
  static const String _endpoint = '/genre/movie/list';

  // [Methods]
  @override
  Future<List<CategoryModel>> getCategories() async {
    final content = await loadMockAsset(FeaturesConfig.category, _endpoint);
    if (content == null) {
      throw ServerException(message: 'No mock for $_endpoint');
    }
    final data = jsonDecode(content) as Map<String, dynamic>;
    final genres = data['genres'] as List<dynamic>;
    return genres
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
