import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // [Constructor]
  HomeBloc() : super(const HomeChipsView()) {
    on<HomeShowChips>((_, emit) => emit(const HomeChipsView()));
    on<HomeShowList>((_, emit) => emit(const HomeListView()));
  }
}
