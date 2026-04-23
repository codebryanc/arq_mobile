import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';

class SaveViewModeUseCase {
  // [Constructor]
  const SaveViewModeUseCase(this._repository);

  // [Properties]
  final ViewModeRepository _repository;

  // [Methods]
  Future<void> call(CategoryViewMode mode) => _repository.saveViewMode(mode);
}
