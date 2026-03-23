import 'package:btg_funds_app/data/enums/navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(AppRoute.home));

  void goToHome() => emit(NavigationState(AppRoute.home));
  void goToExplorer() => emit(NavigationState(AppRoute.explorer));
  void goToHistory() => emit(NavigationState(AppRoute.history));
}