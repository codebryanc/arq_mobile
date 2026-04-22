import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_cast_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_images_usecase.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_event.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  // [Properties]
  final GetMovieDetailUseCase _getMovieDetail;
  final GetMovieCastUseCase _getMovieCast;
  final GetMovieImagesUseCase _getMovieImages;

  // [Constructor]
  MovieDetailBloc({
    required GetMovieDetailUseCase getMovieDetail,
    required GetMovieCastUseCase getMovieCast,
    required GetMovieImagesUseCase getMovieImages,
  }) : _getMovieDetail = getMovieDetail,
       _getMovieCast = getMovieCast,
       _getMovieImages = getMovieImages,
       super(const MovieDetailInitial()) {
    on<LoadMovieDetail>(_onLoadMovieDetail);
  }

  // [Methods]
  Future<void> _onLoadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    // Loading
    emit(const MovieDetailLoading());

    // Call all 3 endpoints in parallel
    final (detailResult, castResult, imagesResult) = await (
      _getMovieDetail(event.movieId),
      _getMovieCast(event.movieId),
      _getMovieImages(event.movieId),
    ).wait;

    detailResult.fold(
      (failure) =>
          // Error
          emit(MovieDetailError(failure)),
      (detail) =>
          // Loaded — cast and images degrade gracefully to empty list if they fail
          emit(
            MovieDetailLoaded(
              detail: detail,
              cast: castResult.fold((_) => [], (c) => c),
              images: imagesResult.fold((_) => [], (i) => i),
            ),
          ),
    );
  }
}
