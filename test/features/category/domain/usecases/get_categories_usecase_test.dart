import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';

class _MockCategoryRepository extends Mock implements CategoryRepository {}

// Test constants
const _kCategoryId = 28;
const _kCategoryName = 'Action';

final _kCategory = Category(id: _kCategoryId, name: _kCategoryName);
final _kCategoryList = [_kCategory];

void main() {
  late _MockCategoryRepository mockRepository;
  late GetCategoriesUseCase useCase;

  setUp(() {
    mockRepository = _MockCategoryRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  group('GetCategoriesUseCase', () {
    test('delegates to repository with isOnline=true', () async {
      // Arrange
      when(
        () => mockRepository.getCategories(isOnline: true),
      ).thenAnswer((_) async => Right(_kCategoryList));

      // Act
      final result = await useCase(const OnlineParams(isOnline: true));

      // Assert
      expect(result, isA<Right<Failure, List<Category>>>());
      result.fold((_) => fail('expected Right'), (cats) {
        expect(cats, equals(_kCategoryList));
      });
      verify(() => mockRepository.getCategories(isOnline: true)).called(1);
    });

    test('delegates to repository with isOnline=false', () async {
      // Arrange
      when(
        () => mockRepository.getCategories(isOnline: false),
      ).thenAnswer((_) async => Right(_kCategoryList));

      // Act
      final result = await useCase(const OnlineParams(isOnline: false));

      // Assert
      result.fold((_) => fail('expected Right'), (cats) {
        expect(cats, equals(_kCategoryList));
      });
      verify(() => mockRepository.getCategories(isOnline: false)).called(1);
    });

    test('returns Left(Failure) when repository returns failure', () async {
      // Arrange
      when(
        () => mockRepository.getCategories(isOnline: true),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await useCase(const OnlineParams(isOnline: true));

      // Assert
      expect(result, isA<Left<Failure, List<Category>>>());
    });
  });
}
