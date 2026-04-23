import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';

class SaveConnectionModeUseCase {
  // [Constructor]
  const SaveConnectionModeUseCase(this._repository);

  // [Properties]
  final ViewModeRepository _repository;

  // [Methods]
  Future<void> call(bool isOnline) => _repository.saveConnectionMode(isOnline);
}
