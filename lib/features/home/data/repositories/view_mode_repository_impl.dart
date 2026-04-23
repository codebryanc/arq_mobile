import 'package:arq_mobile/features/home/data/datasources/view_mode_local_datasource.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';

class ViewModeRepositoryImpl implements ViewModeRepository {
  // [Constructor]
  const ViewModeRepositoryImpl({required this.localDataSource});

  // [Properties]
  final ViewModeLocalDataSource localDataSource;

  // [Methods]
  @override
  CategoryViewMode getViewMode() => localDataSource.getViewMode();

  @override
  Future<void> saveViewMode(CategoryViewMode mode) =>
      localDataSource.saveViewMode(mode);

  @override
  bool getConnectionMode() => localDataSource.getConnectionMode();

  @override
  Future<void> saveConnectionMode(bool isOnline) =>
      localDataSource.saveConnectionMode(isOnline);
}
