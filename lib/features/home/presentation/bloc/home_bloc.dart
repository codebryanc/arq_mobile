import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // [Constructor]
  HomeBloc({
    required GetViewModeUseCase getViewMode,
    required SaveViewModeUseCase saveViewMode,
    required GetConnectionModeUseCase getConnectionMode,
    required SaveConnectionModeUseCase saveConnectionMode,
  }) : _getViewMode = getViewMode,
       _saveViewMode = saveViewMode,
       _getConnectionMode = getConnectionMode,
       _saveConnectionMode = saveConnectionMode,
       super(const HomeChipsView()) {
    on<HomeLoadViewMode>(_onLoad);
    on<HomeShowChips>(_onShowChips);
    on<HomeShowList>(_onShowList);
    on<HomeToggleConnectionMode>(_onToggleConnectionMode);
    add(const HomeLoadViewMode());
  }

  // [Properties]
  final GetViewModeUseCase _getViewMode;
  final SaveViewModeUseCase _saveViewMode;
  final GetConnectionModeUseCase _getConnectionMode;
  final SaveConnectionModeUseCase _saveConnectionMode;

  // [Methods]
  Future<void> _onLoad(HomeLoadViewMode event, Emitter<HomeState> emit) async {
    final viewResult = await _getViewMode(const NoParams());
    final connResult = await _getConnectionMode(const NoParams());

    final isOnline = switch (connResult) {
      Right(:final value) => value,
      Left() => true,
    };

    // Used fold to handle success and error cases explicitly and safely.
    viewResult.fold(
      (_) {},
      (mode) => emit(
        mode == CategoryViewMode.list
            ? HomeListView(isOnline: isOnline)
            : HomeChipsView(isOnline: isOnline),
      ),
    );
  }

  Future<void> _onShowChips(
    HomeShowChips event,
    Emitter<HomeState> emit,
  ) async {
    // Loading
    emit(HomeChipsView(isOnline: state.isOnline));
    await _saveViewMode(CategoryViewMode.chips);
  }

  Future<void> _onShowList(HomeShowList event, Emitter<HomeState> emit) async {
    // Loading
    emit(HomeListView(isOnline: state.isOnline));
    await _saveViewMode(CategoryViewMode.list);
  }

  Future<void> _onToggleConnectionMode(
    HomeToggleConnectionMode event,
    Emitter<HomeState> emit,
  ) async {
    final isOnline = !state.isOnline;
    // Loading
    emit(
      state is HomeListView
          ? HomeListView(isOnline: isOnline)
          : HomeChipsView(isOnline: isOnline),
    );
    await _saveConnectionMode(isOnline);
  }
}
