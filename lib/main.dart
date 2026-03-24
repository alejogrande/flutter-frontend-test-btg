import 'package:btg_funds_app/dependency_injection/dependency_injection.dart' as di;
import 'package:btg_funds_app/presentation/navigation/app_route_delegate.dart';
import 'package:btg_funds_app/presentation/navigation/app_route_parser.dart';
import 'package:btg_funds_app/presentation/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() async {
  // Asegura que los bindings de Flutter estén listos antes de inicializar DI
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa GetIt (Inyector de dependencias)
  di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Se obtiene la instancia del Cubit desde el Service Locator (GetIt)
      create: (_) => di.sl<NavigationCubit>(),
      child: MaterialApp.router(
        title: 'BTG Pactual - Prueba Técnica',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // Configuración de Navigator 2.0
        routerDelegate: AppRouterDelegate(),
        routeInformationParser: AppRouteParser(),
      ),
    );
  }
}