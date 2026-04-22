import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  // [Properties]
  final GetCategoriesUseCase _getCategories;
  Category? selectedCategory;

  // [Constructor]
  CategoryBloc({required GetCategoriesUseCase getCategories, this.selectedCategory})
      : _getCategories = getCategories,
        super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<ClearCategory>(_onClearCategory);
  }

  // [Methods]
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    // Loading
    emit(const CategoryLoading());

    final result = await _getCategories(const NoParams());
    result.fold(
      (failure) =>
          // Error
          emit(CategoryError(failure)),
      (categories) =>
          // Loaded
          emit(CategoryLoaded(categories)),
    );
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    final current = state;
    if (current is CategoryLoaded) {
      // Update selected category
      selectedCategory = event.category;
      
      // Loaded with selected category
      emit(CategoryLoaded(current.categories, selectedCategory: event.category));
    }
  }

  void _onClearCategory(ClearCategory event, Emitter<CategoryState> emit) {
    final current = state;
    if (current is CategoryLoaded) {
      // Loaded with cleared selection
      selectedCategory = null;
      emit(CategoryLoaded(current.categories));
    }
  }
}
