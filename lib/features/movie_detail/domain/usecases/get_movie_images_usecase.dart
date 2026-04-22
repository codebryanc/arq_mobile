import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class GetMovieImagesUseCase implements UseCase<List<MovieImage>, int> {
  // [Properties]
  final MovieDetailRepository _repository;

  // [Constructor]
  const GetMovieImagesUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, List<MovieImage>>> call(int movieId) =>
      _repository.getMovieImages(movieId);
}
