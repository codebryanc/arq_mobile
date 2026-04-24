import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_state.dart';

class _MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

// Test constants
const _kCategoryId = 28;
const _kCategoryName = 'Action';
const _kCategoryId2 = 12;
const _kCategoryName2 = 'Adventure';

final _kCategory = Category(id: _kCategoryId, name: _kCategoryName);
final _kCategory2 = Category(id: _kCategoryId2, name: _kCategoryName2);
final _kCategories = [_kCategory, _kCategory2];

void main() {
  late _MockGetCategoriesUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const OnlineParams(isOnline: true));
  });

  setUp(() {
    mockUseCase = _MockGetCategoriesUseCase();
  });

  CategoryBloc buildBloc() => CategoryBloc(getCategories: mockUseCase);

  group('CategoryBloc', () {
    test('initial state is CategoryInitial', () {
      // Arrange & Act
      final bloc = buildBloc();

      // Assert
      expect(bloc.state, isA<CategoryInitial>());
      bloc.close();
    });

    group('LoadCategories', () {
      blocTest<CategoryBloc, CategoryState>(
        'emits [Loading, Loaded] on success',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(_kCategories));
        },
        act: (bloc) => bloc.add(const LoadCategories(isOnline: true)),
        expect: () => [isA<CategoryLoading>(), isA<CategoryLoaded>()],
      );

      blocTest<CategoryBloc, CategoryState>(
        'loaded state contains categories',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(_kCategories));
        },
        act: (bloc) => bloc.add(const LoadCategories(isOnline: true)),
        verify: (bloc) {
          final loaded = bloc.state as CategoryLoaded;
          expect(loaded.categories, equals(_kCategories));
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'emits [Loading, Error] on failure',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        act: (bloc) => bloc.add(const LoadCategories(isOnline: false)),
        expect: () => [isA<CategoryLoading>(), isA<CategoryError>()],
      );
    });

    group('SelectCategory', () {
      blocTest<CategoryBloc, CategoryState>(
        'updates selectedCategory in loaded state',
        build: buildBloc,
        setUp: () {
          when(
            () => mockUseCase(any()),
          ).thenAnswer((_) async => Right(_kCategories));
        },
        seed: () => CategoryLoaded(_kCategories),
        act: (bloc) => bloc.add(SelectCategory(_kCategory)),
        expect: () => [isA<CategoryLoaded>()],
        verify: (bloc) {
          final loaded = bloc.state as CategoryLoaded;
          expect(loaded.selectedCategory, equals(_kCategory));
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'does nothing when state is not CategoryLoaded',
        build: buildBloc,
        act: (bloc) => bloc.add(SelectCategory(_kCategory)),
        expect: () => [],
      );
    });

    group('ClearCategory', () {
      blocTest<CategoryBloc, CategoryState>(
        'clears selectedCategory in loaded state',
        build: buildBloc,
        seed: () => CategoryLoaded(_kCategories, selectedCategory: _kCategory),
        act: (bloc) => bloc.add(const ClearCategory()),
        expect: () => [isA<CategoryLoaded>()],
        verify: (bloc) {
          final loaded = bloc.state as CategoryLoaded;
          expect(loaded.selectedCategory, isNull);
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'does nothing when state is not CategoryLoaded',
        build: buildBloc,
        act: (bloc) => bloc.add(const ClearCategory()),
        expect: () => [],
      );
    });
  });
}
