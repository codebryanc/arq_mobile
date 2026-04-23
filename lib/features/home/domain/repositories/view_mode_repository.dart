import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';

abstract class ViewModeRepository {
  // [Methods]
  CategoryViewMode getViewMode();
  Future<void> saveViewMode(CategoryViewMode mode);
}
