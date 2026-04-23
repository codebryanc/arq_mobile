import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';

class GetMovieImagesUseCase
    implements UseCase<List<MovieImage>, MovieDetailParams> {
  // [Properties]
  final MovieDetailRepository _repository;

  // [Constructor]
  const GetMovieImagesUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, List<MovieImage>>> call(MovieDetailParams params) =>
      _repository.getMovieImages(params.movieId, isOnline: params.isOnline);
}
