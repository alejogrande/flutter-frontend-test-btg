import 'package:btg_funds_app/data/enums/transaction_type.dart';
import 'package:btg_funds_app/presentation/features/transaction_history/widgets/history_detailed_investment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double maxContentWidth = 1300;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Color(0xFF002C5F),
          ),
          label: const Text(
            'Volver',
            style: TextStyle(color: Color(0xFF002C5F)),
          ),
        ),
        title: Column(
          children: [
            const Text(
              'Histórico de Inversiones',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Inversiones completadas y finalizadas',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final transactions = state.history;

          // Cálculo dinámico para las estadísticas superiores
          double totalRecuperado = 0;
          for (var t in transactions) {
            if (t.type == TransactionType.cancellation) {
              totalRecuperado += t.amount;
            }
          }
          // --- CÁLCULOS DINÁMICOS ---
          final subscriptions = transactions
              .where((t) => t.type == TransactionType.subscription)
              .toList();

          final totalInvested = subscriptions.fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

          // Cálculo de tasa promedio
          double averageRate = 0.0;
          if (subscriptions.isNotEmpty) {
            final sumRates = subscriptions.fold(
              0.0,
              (sum, item) => sum + item.annualRate,
            );
            averageRate = (sumRates / subscriptions.length) * 100;
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth > 600;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            SmallInfoCard(
                              title: 'Total invertido',
                              value: '\$${_format(totalInvested)}',
                              isWide: isWide,
                            ),
                            SmallInfoCard(
                              title: 'Total recuperado',
                              value:
                                  '\$${_format(totalRecuperado)}', 
                              isWide: isWide,
                            ),
                            SmallInfoCard(
                              title: 'Ganancias totales',
                              value: '\$0',
                              isWide: isWide,
                            ),
                            SmallInfoCard(
                              title: 'Retorno promedio',
                              value:
                                  '${averageRate.toStringAsFixed(1)}%', 
                              isWide: isWide,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Inversiones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${transactions.length} inversiones activas y finalizadas',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (transactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text("No hay movimientos registrados"),
                        ),
                      )
                    else
                      ...transactions.map((t) {
                        final bool isSub =
                            t.type == TransactionType.subscription;
                        return DetailedInvestmentCard(
                          title: t.fundName,
                          type: isSub
                              ? 'Fondo de Inversión'
                              : 'Retiro de Capital',
                          initialInvestment: '\$${_format(t.amount)}',
                          profit: isSub ? 'En proceso' : 'Finalizado',
                          startDate:
                              "${t.date.day}/${t.date.month}/${t.date.year}",
                          endDate: isSub ? 'Activa' : 'Finalizada',
                          // Mostramos la tasa individual de cada transacción
                          annualRate:
                              '${(t.annualRate * 100).toStringAsFixed(2)}%',
                          totalGenerated: '\$${_format(t.amount)}',
                          isActive: isSub,
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _format(double val) => val
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}
