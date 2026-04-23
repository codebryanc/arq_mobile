import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/usecases/usecase.dart';
import 'package:arq_mobile/features/home/domain/enums/category_view_mode.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // [Constructor]
  HomeBloc({
    required GetViewModeUseCase getViewMode,
    required SaveViewModeUseCase saveViewMode,
  }) : _getViewMode = getViewMode,
       _saveViewMode = saveViewMode,
       super(const HomeChipsView()) {
    on<HomeLoadViewMode>(_onLoad);
    on<HomeShowChips>(_onShowChips);
    on<HomeShowList>(_onShowList);
    add(const HomeLoadViewMode());
  }

  // [Properties]
  final GetViewModeUseCase _getViewMode;
  final SaveViewModeUseCase _saveViewMode;

  // [Methods]
  Future<void> _onLoad(HomeLoadViewMode event, Emitter<HomeState> emit) async {
    final result = await _getViewMode(const NoParams());

    // Used fold to handle success and error cases explicitly and safely.
    result.fold(
      (_) {},
      (mode) => emit(
        mode == CategoryViewMode.list
            ? const HomeListView()
            : const HomeChipsView(),
      ),
    );
  }

  Future<void> _onShowChips(
    HomeShowChips event,
    Emitter<HomeState> emit,
  ) async {
    // Loading
    emit(const HomeChipsView());
    await _saveViewMode(CategoryViewMode.chips);
  }

  Future<void> _onShowList(HomeShowList event, Emitter<HomeState> emit) async {
    // Loading
    emit(const HomeListView());
    await _saveViewMode(CategoryViewMode.list);
  }
}
