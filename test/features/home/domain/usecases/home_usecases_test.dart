import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_view_mode_usecase.dart';

class _MockViewModeRepository extends Mock implements ViewModeRepository {}

void main() {
  late _MockViewModeRepository mockRepository;

  setUp(() {
    mockRepository = _MockViewModeRepository();
  });

  // ── GetViewModeUseCase ──────────────────────────────────────────

  group('GetViewModeUseCase', () {
    late GetViewModeUseCase useCase;

    setUp(() => useCase = GetViewModeUseCase(mockRepository));

    test('returns Right(chips) from repository', () async {
      // Arrange
      when(() => mockRepository.getViewMode())
          .thenReturn(CategoryViewMode.chips);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      result.fold((_) => fail('expected Right'), (mode) {
        expect(mode, equals(CategoryViewMode.chips));
      });
      verify(() => mockRepository.getViewMode()).called(1);
    });

    test('returns Right(list) from repository', () async {
      // Arrange
      when(() => mockRepository.getViewMode())
          .thenReturn(CategoryViewMode.list);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      result.fold((_) => fail('expected Right'), (mode) {
        expect(mode, equals(CategoryViewMode.list));
      });
    });
  });

  // ── SaveViewModeUseCase ─────────────────────────────────────────

  group('SaveViewModeUseCase', () {
    late SaveViewModeUseCase useCase;

    setUp(() => useCase = SaveViewModeUseCase(mockRepository));

    test('delegates saveViewMode(list) to repository', () async {
      // Arrange
      when(() => mockRepository.saveViewMode(CategoryViewMode.list))
          .thenAnswer((_) async {});

      // Act
      await useCase(CategoryViewMode.list);

      // Assert
      verify(() => mockRepository.saveViewMode(CategoryViewMode.list))
          .called(1);
    });

    test('delegates saveViewMode(chips) to repository', () async {
      // Arrange
      when(() => mockRepository.saveViewMode(CategoryViewMode.chips))
          .thenAnswer((_) async {});

      // Act
      await useCase(CategoryViewMode.chips);

      // Assert
      verify(() => mockRepository.saveViewMode(CategoryViewMode.chips))
          .called(1);
    });
  });

  // ── GetConnectionModeUseCase ────────────────────────────────────

  group('GetConnectionModeUseCase', () {
    late GetConnectionModeUseCase useCase;

    setUp(() => useCase = GetConnectionModeUseCase(mockRepository));

    test('returns Right(true) when online', () async {
      // Arrange
      when(() => mockRepository.getConnectionMode()).thenReturn(true);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      result.fold((_) => fail('expected Right'), (isOnline) {
        expect(isOnline, isTrue);
      });
      verify(() => mockRepository.getConnectionMode()).called(1);
    });

    test('returns Right(false) when offline', () async {
      // Arrange
      when(() => mockRepository.getConnectionMode()).thenReturn(false);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      result.fold((_) => fail('expected Right'), (isOnline) {
        expect(isOnline, isFalse);
      });
    });
  });

  // ── SaveConnectionModeUseCase ───────────────────────────────────

  group('SaveConnectionModeUseCase', () {
    late SaveConnectionModeUseCase useCase;

    setUp(() => useCase = SaveConnectionModeUseCase(mockRepository));

    test('delegates saveConnectionMode(true) to repository', () async {
      // Arrange
      when(() => mockRepository.saveConnectionMode(true))
          .thenAnswer((_) async {});

      // Act
      await useCase(true);

      // Assert
      verify(() => mockRepository.saveConnectionMode(true)).called(1);
    });

    test('delegates saveConnectionMode(false) to repository', () async {
      // Arrange
      when(() => mockRepository.saveConnectionMode(false))
          .thenAnswer((_) async {});

      // Act
      await useCase(false);

      // Assert
      verify(() => mockRepository.saveConnectionMode(false)).called(1);
    });
  });
}
