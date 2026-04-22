import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  const GetCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      _repository.getCategories();
}
