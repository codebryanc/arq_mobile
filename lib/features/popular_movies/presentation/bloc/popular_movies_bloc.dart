import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/features/popular_movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_event.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  // [Properties]
  final GetPopularMoviesUseCase _getPopularMovies;

  // [Constructor]
  PopularMoviesBloc({required GetPopularMoviesUseCase getPopularMovies})
    : _getPopularMovies = getPopularMovies,
      super(const PopularMoviesInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
  }

  // [Methods]
  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    // Loading
    emit(const PopularMoviesLoading());

    final result = await _getPopularMovies(OnlineParams(isOnline: event.isOnline));
    result.fold(
      (failure) =>
          // Error
          emit(PopularMoviesError(failure)),
      (movies) =>
          // Loaded
          emit(PopularMoviesLoaded(movies)),
    );
  }
}
