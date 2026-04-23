import 'package:shared_preferences/shared_preferences.dart';

import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';

abstract class ViewModeLocalDataSource {
  // [Methods]
  CategoryViewMode getViewMode();
  Future<void> saveViewMode(CategoryViewMode mode);
}

class ViewModeLocalDataSourceImpl implements ViewModeLocalDataSource {
  // [Constructor]
  const ViewModeLocalDataSourceImpl({required this.prefs});

  // [Properties]
  final SharedPreferences prefs;

  static const _key = 'SavedViewMode';

  // [Methods]
  @override
  CategoryViewMode getViewMode() {
    final saved = prefs.getString(_key);
    return CategoryViewMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => CategoryViewMode.chips,
    );
  }

  @override
  Future<void> saveViewMode(CategoryViewMode mode) =>
      prefs.setString(_key, mode.name);
}
