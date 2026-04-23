sealed class HomeState {
  const HomeState({this.isOnline = true});

  // [Properties]
  final bool isOnline;
}

final class HomeChipsView extends HomeState {
  const HomeChipsView({super.isOnline = true});
}

final class HomeListView extends HomeState {
  const HomeListView({super.isOnline = true});
}
