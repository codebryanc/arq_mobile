import 'package:arq_mobile/core/errors/failures.dart';

import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

sealed class MoviesByCategoryState {
  const MoviesByCategoryState();
}

final class MoviesByCategoryInitial extends MoviesByCategoryState {
  const MoviesByCategoryInitial();
}

final class MoviesByCategoryLoading extends MoviesByCategoryState {
  const MoviesByCategoryLoading();
}

final class MoviesByCategoryLoaded extends MoviesByCategoryState {
  // [Constructor]
  const MoviesByCategoryLoaded(
    this.movies, {
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  // [Properties]
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  bool get hasMore => currentPage < totalPages;

  // [Methods]
  // States are immutable — copyWith lets the bloc emit a new state based on
  // the current one, changing only the fields that need to update.
  MoviesByCategoryLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) =>
      MoviesByCategoryLoaded(
        movies ?? this.movies,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

final class MoviesByCategoryError extends MoviesByCategoryState {
  // [Constructor]
  const MoviesByCategoryError(this.failure);

  // [Properties]
  final Failure failure;
}
