import 'package:arq_mobile/features/category/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  // [Methods]
  @override
  Future<List<CategoryModel>> getCategories() async => [];
}
