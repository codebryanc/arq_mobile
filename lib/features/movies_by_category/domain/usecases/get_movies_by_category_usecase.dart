import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';

import 'package:arq_mobile/features/movies_by_category/domain/repositories/movies_by_category_repository.dart';
import 'package:arq_mobile/features/popular_movies/domain/entities/movie.dart';

class CategoryParams {
  // [Constructor]
  const CategoryParams({
    required this.categoryId,
    required this.isOnline,
    this.page = 1,
  });

  // [Properties]
  final int categoryId;
  final int page;
  final bool isOnline;
}

class GetMoviesByCategoryUseCase
    implements UseCase<(List<Movie>, int), CategoryParams> {
  // [Properties]
  final MoviesByCategoryRepository _repository;

  // [Constructor]
  const GetMoviesByCategoryUseCase(this._repository);

  // [Methods]
  @override
  Future<Either<Failure, (List<Movie>, int)>> call(CategoryParams params) =>
      _repository.getMoviesByCategory(
        params.categoryId,
        params.page,
        isOnline: params.isOnline,
      );
}
