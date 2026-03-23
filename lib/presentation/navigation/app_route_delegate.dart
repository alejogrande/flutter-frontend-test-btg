import 'package:btg_funds_app/data/enums/navigation_state.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/funds_list_screen.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/home_screen.dart';
import 'package:btg_funds_app/presentation/features/transaction_history/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_cubit.dart';

class AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Navigator(
          key: navigatorKey,
          pages: [
            // La Home siempre está en la base
             MaterialPage(child: HomeScreen()),

            // Si el estado cambia, se agrega la paquina al stack de navegacion
            if (state.currentRoute == AppRoute.explorer)
               MaterialPage(child: FundsListScreen()),

            if (state.currentRoute == AppRoute.history)
               MaterialPage(child: HistoryScreen()),
          ],
          // ignore: deprecated_member_use
          onPopPage: (Route<dynamic> route, dynamic result) {
            if (!route.didPop(result)) {
              return false;
            }

            // Se actualiza el cubit para que reconozca que se volvio al Home
            context.read<NavigationCubit>().goToHome();
            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}
