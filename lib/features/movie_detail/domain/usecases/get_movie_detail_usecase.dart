import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';

class MovieDetailParams {
  // [Constructor]
  const MovieDetailParams({required this.movieId, required this.isOnline});

  // [Properties]
  final int movieId;
  final bool isOnline;
}

class GetMovieDetailUseCase implements UseCase<MovieDetail, MovieDetailParams> {
  // [Properties]
  final MovieDetailRepository _repository;

  // [Constructor]
  const GetMovieDetailUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, MovieDetail>> call(MovieDetailParams params) =>
      _repository.getMovieDetail(params.movieId, isOnline: params.isOnline);
}
