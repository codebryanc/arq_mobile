import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';

class GetViewModeUseCase implements UseCase<CategoryViewMode, NoParams> {
  // [Constructor]
  const GetViewModeUseCase(this._repository);

  // [Properties]
  final ViewModeRepository _repository;

  // [Methods]
  @override
  Future<Either<Failure, CategoryViewMode>> call(NoParams params) async =>
      Right(_repository.getViewMode());
}
