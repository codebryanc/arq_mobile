import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  // [Properties]
  final GetCategoriesUseCase _getCategories;

  // [Constructor]
  CategoryBloc({required GetCategoriesUseCase getCategories})
      : _getCategories = getCategories,
        super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  // [Methods]
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    // Loading
    emit(const CategoryLoading());
    
    // Get categories
    final result = await _getCategories(const NoParams());
    result.fold(
      (failure) => emit(CategoryError(failure)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
