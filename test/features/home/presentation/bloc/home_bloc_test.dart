import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';

class _MockGetViewModeUseCase extends Mock implements GetViewModeUseCase {}

class _MockSaveViewModeUseCase extends Mock implements SaveViewModeUseCase {}

class _MockGetConnectionModeUseCase extends Mock
    implements GetConnectionModeUseCase {}

class _MockSaveConnectionModeUseCase extends Mock
    implements SaveConnectionModeUseCase {}

void main() {
  late _MockGetViewModeUseCase mockGetViewMode;
  late _MockSaveViewModeUseCase mockSaveViewMode;
  late _MockGetConnectionModeUseCase mockGetConnectionMode;
  late _MockSaveConnectionModeUseCase mockSaveConnectionMode;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(CategoryViewMode.chips);
  });

  setUp(() {
    mockGetViewMode = _MockGetViewModeUseCase();
    mockSaveViewMode = _MockSaveViewModeUseCase();
    mockGetConnectionMode = _MockGetConnectionModeUseCase();
    mockSaveConnectionMode = _MockSaveConnectionModeUseCase();
  });

  // HomeBloc dispatches HomeLoadViewMode in constructor automatically.
  // bloc_test calls setUp() before build(), so mocks are ready in time.
  HomeBloc buildBloc() => HomeBloc(
    getViewMode: mockGetViewMode,
    saveViewMode: mockSaveViewMode,
    getConnectionMode: mockGetConnectionMode,
    saveConnectionMode: mockSaveConnectionMode,
  );

  // Stubs load use cases to avoid MissingStubError on auto-dispatched event.
  void stubLoad({
    CategoryViewMode viewMode = CategoryViewMode.chips,
    bool isOnline = true,
  }) {
    when(() => mockGetViewMode(any())).thenAnswer((_) async => Right(viewMode));
    when(
      () => mockGetConnectionMode(any()),
    ).thenAnswer((_) async => Right(isOnline));
  }

  group('HomeBloc', () {
    // ── HomeLoadViewMode (auto-dispatched on construction) ──────────

    group('HomeLoadViewMode', () {
      blocTest<HomeBloc, HomeState>(
        'emits HomeChipsView when saved mode is chips and online',
        setUp: () => stubLoad(viewMode: CategoryViewMode.chips, isOnline: true),
        build: buildBloc,
        expect: () => [isA<HomeChipsView>()],
        verify: (bloc) => expect(bloc.state.isOnline, isTrue),
      );

      blocTest<HomeBloc, HomeState>(
        'emits HomeListView when saved mode is list',
        setUp: () => stubLoad(viewMode: CategoryViewMode.list, isOnline: true),
        build: buildBloc,
        expect: () => [isA<HomeListView>()],
      );

      blocTest<HomeBloc, HomeState>(
        'emits HomeChipsView with isOnline=false when offline is saved',
        setUp: () =>
            stubLoad(viewMode: CategoryViewMode.chips, isOnline: false),
        build: buildBloc,
        expect: () => [isA<HomeChipsView>()],
        verify: (bloc) => expect(bloc.state.isOnline, isFalse),
      );

      blocTest<HomeBloc, HomeState>(
        'defaults isOnline to true when GetConnectionMode returns Left',
        setUp: () {
          when(
            () => mockGetViewMode(any()),
          ).thenAnswer((_) async => Right(CategoryViewMode.chips));
          when(
            () => mockGetConnectionMode(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        build: buildBloc,
        expect: () => [isA<HomeChipsView>()],
        verify: (bloc) => expect(bloc.state.isOnline, isTrue),
      );

      blocTest<HomeBloc, HomeState>(
        'emits no additional state when GetViewMode returns Left',
        setUp: () {
          when(
            () => mockGetViewMode(any()),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
          when(
            () => mockGetConnectionMode(any()),
          ).thenAnswer((_) async => const Right(true));
        },
        build: buildBloc,
        expect: () => [],
      );
    });

    // ── HomeShowChips ───────────────────────────────────────────────
    // act fires first (HomeChipsView), then auto-load fires second (HomeChipsView)

    group('HomeShowChips', () {
      blocTest<HomeBloc, HomeState>(
        'emits HomeChipsView and persists chips mode',
        setUp: () {
          stubLoad();
          when(() => mockSaveViewMode(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeShowChips()),
        expect: () => [isA<HomeChipsView>(), isA<HomeChipsView>()],
        verify: (_) =>
            verify(() => mockSaveViewMode(CategoryViewMode.chips)).called(1),
      );
    });

    // ── HomeShowList ────────────────────────────────────────────────
    // act fires first (HomeListView), then auto-load fires second (HomeChipsView)

    group('HomeShowList', () {
      blocTest<HomeBloc, HomeState>(
        'emits HomeListView and persists list mode',
        setUp: () {
          stubLoad();
          when(() => mockSaveViewMode(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeShowList()),
        expect: () => [isA<HomeListView>(), isA<HomeChipsView>()],
        verify: (_) =>
            verify(() => mockSaveViewMode(CategoryViewMode.list)).called(1),
      );
    });

    // ── HomeToggleConnectionMode ────────────────────────────────────
    // act fires first (toggled state), then auto-load fires second (original)

    group('HomeToggleConnectionMode', () {
      blocTest<HomeBloc, HomeState>(
        'flips isOnline from true to false in chips view',
        setUp: () {
          stubLoad(viewMode: CategoryViewMode.chips, isOnline: true);
          when(() => mockSaveConnectionMode(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const HomeToggleConnectionMode()),
        expect: () => [
          // act: chips view toggled to offline
          predicate<HomeState>((s) => s is HomeChipsView && !s.isOnline),
          // auto-load: chips view, online (from stub)
          isA<HomeChipsView>(),
        ],
        verify: (_) => verify(() => mockSaveConnectionMode(false)).called(1),
      );

      blocTest<HomeBloc, HomeState>(
        'flips isOnline from true to false in list view',
        setUp: () {
          stubLoad(viewMode: CategoryViewMode.list, isOnline: true);
          when(() => mockSaveConnectionMode(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        // Seed HomeListView so toggle sees list state before auto-load fires
        seed: () => const HomeListView(isOnline: true),
        act: (bloc) => bloc.add(const HomeToggleConnectionMode()),
        expect: () => [
          // act: list view toggled to offline
          predicate<HomeState>((s) => s is HomeListView && !s.isOnline),
          // auto-load: list view, online (from stub)
          isA<HomeListView>(),
        ],
        verify: (_) => verify(() => mockSaveConnectionMode(false)).called(1),
      );
    });
  });
}
