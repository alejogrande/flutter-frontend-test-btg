import 'package:btg_funds_app/presentation/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BTG - Resumen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Saldo: 500.000', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<NavigationCubit>().goToExplorer(),
              child: const Text('Explorar Fondos'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.read<NavigationCubit>().goToHistory(),
              child: const Text('Ver Historial'),
            ),
          ],
        ),
      ),
    );
  }
}