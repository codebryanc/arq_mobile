import 'package:shared_preferences/shared_preferences.dart';

import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';

abstract class ViewModeLocalDataSource {
  // [Methods]
  CategoryViewMode getViewMode();
  Future<void> saveViewMode(CategoryViewMode mode);
  bool getConnectionMode();
  Future<void> saveConnectionMode(bool isOnline);
}

class ViewModeLocalDataSourceImpl implements ViewModeLocalDataSource {
  // [Constructor]
  const ViewModeLocalDataSourceImpl({required this.prefs});

  // [Properties]
  final SharedPreferences prefs;

  static const _viewModeKey = 'SavedViewMode';
  static const _connectionModeKey = 'SavedConnectionMode';

  // [Methods]
  @override
  CategoryViewMode getViewMode() {
    final saved = prefs.getString(_viewModeKey);
    return CategoryViewMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => CategoryViewMode.chips,
    );
  }

  @override
  Future<void> saveViewMode(CategoryViewMode mode) =>
      prefs.setString(_viewModeKey, mode.name);

  @override
  bool getConnectionMode() => prefs.getBool(_connectionModeKey) ?? true;

  @override
  Future<void> saveConnectionMode(bool isOnline) =>
      prefs.setBool(_connectionModeKey, isOnline);
}
