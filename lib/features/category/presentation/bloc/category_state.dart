import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';

sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryLoaded extends CategoryState {
  const CategoryLoaded(this.categories);

  final List<Category> categories;
}

final class CategoryError extends CategoryState {
  const CategoryError(this.failure);

  final Failure failure;
}
