import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class GetMovieDetailUseCase implements UseCase<MovieDetail, int> {
  // [Properties]
  final MovieDetailRepository _repository;

  // [Constructor]
  const GetMovieDetailUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, MovieDetail>> call(int movieId) =>
      _repository.getMovieDetail(movieId);
}
