import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';

sealed class MovieDetailState {
  const MovieDetailState();
}

final class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

final class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

final class MovieDetailLoaded extends MovieDetailState {
  // [Constructor]
  const MovieDetailLoaded({
    required this.detail,
    required this.cast,
    required this.images,
  });

  // [Properties]
  final MovieDetail detail;
  final List<Actor> cast;
  final List<MovieImage> images;
}

final class MovieDetailError extends MovieDetailState {
  // [Constructor]
  const MovieDetailError(this.failure);

  // [Properties]
  final Failure failure;
}
