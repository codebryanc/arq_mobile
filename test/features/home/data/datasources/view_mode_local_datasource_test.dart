import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:arq_mobile/features/home/data/datasources/view_mode_local_datasource.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

// Test constants
const _kViewModeKey = 'SavedViewMode';
const _kConnectionModeKey = 'SavedConnectionMode';
const _kListModeName = 'list';

void main() {
  late _MockSharedPreferences mockPrefs;
  late ViewModeLocalDataSourceImpl dataSource;

  setUp(() {
    mockPrefs = _MockSharedPreferences();
    dataSource = ViewModeLocalDataSourceImpl(prefs: mockPrefs);
  });

  group('ViewModeLocalDataSource', () {
    group('getViewMode', () {
      test('returns list mode when saved value is list', () {
        // Arrange
        when(() => mockPrefs.getString(_kViewModeKey))
            .thenReturn(_kListModeName);

        // Act
        final result = dataSource.getViewMode();

        // Assert
        expect(result, equals(CategoryViewMode.list));
      });

      test('returns chips mode when saved value is chips', () {
        // Arrange
        when(() => mockPrefs.getString(_kViewModeKey))
            .thenReturn(CategoryViewMode.chips.name);

        // Act
        final result = dataSource.getViewMode();

        // Assert
        expect(result, equals(CategoryViewMode.chips));
      });

      test('defaults to chips when saved value is null', () {
        // Arrange
        when(() => mockPrefs.getString(_kViewModeKey)).thenReturn(null);

        // Act
        final result = dataSource.getViewMode();

        // Assert
        expect(result, equals(CategoryViewMode.chips));
      });

      test('defaults to chips when saved value is unrecognized', () {
        // Arrange
        when(() => mockPrefs.getString(_kViewModeKey)).thenReturn('unknown');

        // Act
        final result = dataSource.getViewMode();

        // Assert
        expect(result, equals(CategoryViewMode.chips));
      });
    });

    group('saveViewMode', () {
      test('persists the mode name to prefs', () async {
        // Arrange
        when(() => mockPrefs.setString(_kViewModeKey, _kListModeName))
            .thenAnswer((_) async => true);

        // Act
        await dataSource.saveViewMode(CategoryViewMode.list);

        // Assert
        verify(
          () => mockPrefs.setString(_kViewModeKey, _kListModeName),
        ).called(1);
      });
    });

    group('getConnectionMode', () {
      test('returns true when prefs returns true', () {
        // Arrange
        when(() => mockPrefs.getBool(_kConnectionModeKey)).thenReturn(true);

        // Act
        final result = dataSource.getConnectionMode();

        // Assert
        expect(result, isTrue);
      });

      test('returns false when prefs returns false', () {
        // Arrange
        when(() => mockPrefs.getBool(_kConnectionModeKey)).thenReturn(false);

        // Act
        final result = dataSource.getConnectionMode();

        // Assert
        expect(result, isFalse);
      });

      test('defaults to true when prefs returns null', () {
        // Arrange
        when(() => mockPrefs.getBool(_kConnectionModeKey)).thenReturn(null);

        // Act
        final result = dataSource.getConnectionMode();

        // Assert
        expect(result, isTrue);
      });
    });

    group('saveConnectionMode', () {
      test('persists the value to prefs', () async {
        // Arrange
        when(() => mockPrefs.setBool(_kConnectionModeKey, false))
            .thenAnswer((_) async => true);

        // Act
        await dataSource.saveConnectionMode(false);

        // Assert
        verify(() => mockPrefs.setBool(_kConnectionModeKey, false)).called(1);
      });
    });
  });
}
