import 'package:btg_funds_app/dependency_injection/dependency_injection.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/widgets/investment_bottom_sheet.dart';
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
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountSubscriptionError) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.errorMessage}'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is AccountSubscriptionSuccess) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${state.message}'),
                backgroundColor: const Color(0xFF002C5F),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
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
                  separatorBuilder: (_, _) => const Divider(),
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
                        _openInvestmentModal(context, fund);
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
                        onPressed: () =>
                            context.read<FundsBloc>().add(FetchFundsEvent()),
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
      ),
    );
  }
}

void _openInvestmentModal(BuildContext context, FundEntity fund) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que el modal suba con el teclado
    backgroundColor: Colors.transparent, // Para que se vea el redondeado
    builder: (context) => InvestmentBottomSheet(
      fund: fund,
      onConfirm: (amount) {
        // Disparamos el evento al BLoC que ya configuramos
        context.read<AccountBloc>().add(
          SubscribeToFundEvent(
            fundName: fund.name,
            amount: amount,
            minAmount: fund.minimumAmount,
          ),
        );
      },
    ),
  );
}
