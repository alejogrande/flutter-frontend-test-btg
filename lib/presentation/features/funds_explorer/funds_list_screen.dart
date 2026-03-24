import 'package:btg_funds_app/dependency_injection/dependency_injection.dart';
import 'package:btg_funds_app/presentation/navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/funds_bloc.dart';
import 'bloc/funds_event.dart';
import 'bloc/funds_state.dart';

class FundsListScreen extends StatelessWidget {
  const FundsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Envolvemos con el BlocProvider recuperando la instancia de GetIt (sl)
    return BlocProvider(
      create: (context) => sl<FundsBloc>()..add(FetchFundsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fondos Disponibles'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.read<NavigationCubit>().goToHome(),
          ),
        ),
        body: BlocBuilder<FundsBloc, FundsState>(
          builder: (context, state) {
            // 2. Manejo de estado: Cargando
            if (state is FundsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 3. Manejo de estado: Éxito (Lista cargada)
            if (state is FundsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.funds.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final fund = state.funds[index];
                  return ListTile(
                    title: Text(
                      fund.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Categoría: ${fund.category}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Mínimo', style: TextStyle(fontSize: 12)),
                        Text(
                          '\$${fund.minimumAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Aquí irá la lógica para abrir el modal de suscripción
                    },
                  );
                },
              );
            }

            // 4. Manejo de estado: Error
            if (state is FundsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () => context.read<FundsBloc>().add(FetchFundsEvent()),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}