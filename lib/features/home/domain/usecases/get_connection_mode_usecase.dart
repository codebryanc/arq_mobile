import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';

class GetConnectionModeUseCase implements UseCase<bool, NoParams> {
  // [Constructor]
  const GetConnectionModeUseCase(this._repository);

  // [Properties]
  final ViewModeRepository _repository;

  // [Methods]
  @override
  Future<Either<Failure, bool>> call(NoParams params) async =>
      Right(_repository.getConnectionMode());
}
