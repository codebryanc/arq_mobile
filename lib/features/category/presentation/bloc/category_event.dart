import 'package:arq_mobile/features/category/domain/entities/category.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

final class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

final class SelectCategory extends CategoryEvent {
  const SelectCategory(this.category);

  final Category category;
}

final class ClearCategory extends CategoryEvent {
  const ClearCategory();
}
