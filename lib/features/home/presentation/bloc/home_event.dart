sealed class HomeEvent {
  const HomeEvent();
}

final class HomeLoadViewMode extends HomeEvent {
  const HomeLoadViewMode();
}

final class HomeShowChips extends HomeEvent {
  const HomeShowChips();
}

final class HomeShowList extends HomeEvent {
  const HomeShowList();
}

final class HomeToggleConnectionMode extends HomeEvent {
  const HomeToggleConnectionMode();
}
