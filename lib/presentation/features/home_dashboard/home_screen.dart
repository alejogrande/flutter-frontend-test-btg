import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/data/enums/transaction_type.dart'; // Importante para filtrar
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_action_card.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_active_investments_card.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_balance_card.dart';
import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double maxContentWidth = 1300;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Portal de Inversiones',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          // --- CÁLCULOS DINÁMICOS ---
          final transactions = state.history;
          
          // Filtramos solo las suscripciones (inversiones activas/realizadas)
          final subscriptions = transactions
              .where((t) => t.type == TransactionType.subscription)
              .toList();

          final totalInvested = subscriptions.fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

          // Rentabilidad esperada (Tasa promedio de tus inversiones actuales)
          double averageRate = 0.0;
          if (subscriptions.isNotEmpty) {
            final sumRates = subscriptions.fold(
              0.0,
              (sum, item) => sum + item.annualRate,
            );
            averageRate = (sumRates / subscriptions.length) * 100;
          }

          // Ganancias estimadas (Simplificado: Basado en el total invertido y la tasa promedio)
          final estimatedGains = totalInvested * (averageRate / 100);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BalanceCard(),
                    const SizedBox(height: 24),

                    // --- FILA DE 3 CARDS ACTUALIZADA ---
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth > 500;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            SmallInfoCard(
                              title: 'Total invertido',
                              value: '\$${_format(totalInvested)}',
                              isWide: isWide,
                            ),
                            SmallInfoCard(
                              title: 'Rentabilidad esperada', // Cambio de label
                              value: '${averageRate.toStringAsFixed(2)}%',
                              isWide: isWide,
                            ),
                            SmallInfoCard(
                              title: 'Ganancias',
                              value: '\$${_format(estimatedGains)}',
                              isWide: isWide,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // --- BOTONES DE ACCIÓN ---
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        HomeActionButton(
                          title: 'Inversiones disponibles',
                          subtitle: 'Explora nuevas inversiones',
                          icon: Icons.auto_graph_rounded,
                          iconContainerColor: const Color(0xFF7E57C2),
                          backgroundColor: const Color(0xFFF3E5F5),
                          onTap: () =>
                              context.read<NavigationCubit>().goToExplorer(),
                        ),
                        HomeActionButton(
                          title: 'Histórico de inversiones',
                          subtitle: 'Revisa tus inversiones pasadas',
                          icon: Icons.history_rounded,
                          iconContainerColor: const Color(0xFF2E7D32),
                          backgroundColor: Colors.white,
                          onTap: () =>
                              context.read<NavigationCubit>().goToHistory(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    // --- LISTA DE INVERSIONES ACTIVAS ---
                    const ActiveInvestmentsCard(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Función de formateo consistente con el resto de la app
  String _format(double val) => val
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}