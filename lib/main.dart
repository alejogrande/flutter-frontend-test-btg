import 'package:btg_funds_app/dependency_injection/dependency_injection.dart' as di;
import 'package:btg_funds_app/core/navigation/app_route_delegate.dart';
import 'package:btg_funds_app/core/navigation/app_route_parser.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 1. Importa la inicialización de fechas
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa los datos de formato para español (o el idioma que uses en formatters.dart)
  // Esto carga los nombres de meses y días necesarios para formatDate
  await initializeDateFormatting('es_CO', null);

  // Inicializa GetIt
  await di.init(); // Asegúrate de que tu di.init() sea async si carga algo externo

  runApp(
    BlocProvider(
      create: (context) => di.sl<AccountBloc>()..add(LoadAccountInfoEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<NavigationCubit>(),
      child: MaterialApp.router(
        title: 'BTG Pactual - Prueba Técnica',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Actualizado para Material 3
          useMaterial3: true
        ),
        routerDelegate: AppRouterDelegate(),
        routeInformationParser: AppRouteParser(),
      ),
    );
  }
}