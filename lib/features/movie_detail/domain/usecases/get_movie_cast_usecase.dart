import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/actor.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';

class GetMovieCastUseCase implements UseCase<List<Actor>, MovieDetailParams> {
  // [Properties]
  final MovieDetailRepository _repository;

  // [Constructor]
  const GetMovieCastUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, List<Actor>>> call(MovieDetailParams params) =>
      _repository.getMovieCast(params.movieId, isOnline: params.isOnline);
}
