import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/features/home/data/datasources/view_mode_local_datasource.dart';
import 'package:arq_mobile/features/home/data/repositories/view_mode_repository_impl.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';

class _MockViewModeLocalDataSource extends Mock
    implements ViewModeLocalDataSource {}

void main() {
  late _MockViewModeLocalDataSource mockDataSource;
  late ViewModeRepositoryImpl repository;

  setUp(() {
    mockDataSource = _MockViewModeLocalDataSource();
    repository = ViewModeRepositoryImpl(localDataSource: mockDataSource);
  });

  group('ViewModeRepositoryImpl', () {
    group('getViewMode', () {
      test('delegates to local datasource and returns the mode', () {
        // Arrange
        when(() => mockDataSource.getViewMode())
            .thenReturn(CategoryViewMode.list);

        // Act
        final result = repository.getViewMode();

        // Assert
        expect(result, equals(CategoryViewMode.list));
        verify(() => mockDataSource.getViewMode()).called(1);
      });
    });

    group('saveViewMode', () {
      test('delegates to local datasource', () async {
        // Arrange
        when(() => mockDataSource.saveViewMode(CategoryViewMode.chips))
            .thenAnswer((_) async {});

        // Act
        await repository.saveViewMode(CategoryViewMode.chips);

        // Assert
        verify(() => mockDataSource.saveViewMode(CategoryViewMode.chips))
            .called(1);
      });
    });

    group('getConnectionMode', () {
      test('delegates to local datasource and returns the value', () {
        // Arrange
        when(() => mockDataSource.getConnectionMode()).thenReturn(false);

        // Act
        final result = repository.getConnectionMode();

        // Assert
        expect(result, isFalse);
        verify(() => mockDataSource.getConnectionMode()).called(1);
      });
    });

    group('saveConnectionMode', () {
      test('delegates to local datasource', () async {
        // Arrange
        when(() => mockDataSource.saveConnectionMode(true))
            .thenAnswer((_) async {});

        // Act
        await repository.saveConnectionMode(true);

        // Assert
        verify(() => mockDataSource.saveConnectionMode(true)).called(1);
      });
    });
  });
}
