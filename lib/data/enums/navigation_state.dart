enum AppRoute { home, explorer, history }

class NavigationState {
  final AppRoute currentRoute;

  NavigationState(this.currentRoute);
}