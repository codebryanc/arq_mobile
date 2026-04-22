sealed class MoviesByCategoryEvent {
  const MoviesByCategoryEvent();
}

final class LoadMoviesByCategory extends MoviesByCategoryEvent {
  // [Constructor]
  const LoadMoviesByCategory({required this.categoryId, this.page = 1});

  // [Properties]
  final int categoryId;
  final int page;
}

final class LoadMoreMoviesByCategory extends MoviesByCategoryEvent {
  const LoadMoreMoviesByCategory();
}
