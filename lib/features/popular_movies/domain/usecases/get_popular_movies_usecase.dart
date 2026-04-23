import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';
import 'package:arq_mobile/features/popular_movies/domain/repositories/popular_movies_repository.dart';

class GetPopularMoviesUseCase implements UseCase<List<Movie>, OnlineParams> {
  // [Properties]
  final PopularMoviesRepository _repository;

  // [Constructor]
  const GetPopularMoviesUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, List<Movie>>> call(OnlineParams params) =>
      _repository.getPopularMovies(isOnline: params.isOnline);
}
