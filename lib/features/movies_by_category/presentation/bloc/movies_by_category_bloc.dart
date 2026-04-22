import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/features/movies_by_category/domain/usecases/get_movies_by_category_usecase.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_event.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_state.dart';

class MoviesByCategoryBloc
    extends Bloc<MoviesByCategoryEvent, MoviesByCategoryState> {
  // [Properties]
  final GetMoviesByCategoryUseCase _getMoviesByCategory;
  int? _currentCategoryId;

  // [Constructor]
  MoviesByCategoryBloc({
    required GetMoviesByCategoryUseCase getMoviesByCategory,
  })  : _getMoviesByCategory = getMoviesByCategory,
        super(const MoviesByCategoryInitial()) {
    on<LoadMoviesByCategory>(_onLoadMoviesByCategory);
    on<LoadMoreMoviesByCategory>(_onLoadMoreMoviesByCategory);
  }

  // [Methods]
  Future<void> _onLoadMoviesByCategory(
    LoadMoviesByCategory event,
    Emitter<MoviesByCategoryState> emit,
  ) async {
    _currentCategoryId = event.categoryId;

    // Loading
    emit(const MoviesByCategoryLoading());

    final result = await _getMoviesByCategory(
      CategoryParams(categoryId: event.categoryId, page: event.page),
    );
    result.fold(
      (failure) =>
          // Error
          emit(MoviesByCategoryError(failure)),
      (record) {
        final (movies, totalPages) = record;
        // Loaded
        emit(MoviesByCategoryLoaded(
          movies,
          currentPage: event.page,
          totalPages: totalPages,
        ));
      },
    );
  }

  Future<void> _onLoadMoreMoviesByCategory(
    LoadMoreMoviesByCategory event,
    Emitter<MoviesByCategoryState> emit,
  ) async {
    final current = state;
    if (current is! MoviesByCategoryLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;
    if (_currentCategoryId == null) return;

    final nextPage = current.currentPage + 1;

    // Loading more
    emit(current.copyWith(isLoadingMore: true));

    final result = await _getMoviesByCategory(
      CategoryParams(categoryId: _currentCategoryId!, page: nextPage),
    );
    result.fold(
      (failure) =>
          // Error — keep existing movies, stop loading more
          emit(current.copyWith(isLoadingMore: false)),
      (record) {
        final (movies, totalPages) = record;
        // Loaded more — append to existing list
        emit(current.copyWith(
          movies: [...current.movies, ...movies],
          currentPage: nextPage,
          totalPages: totalPages,
          isLoadingMore: false,
        ));
      },
    );
  }
}
