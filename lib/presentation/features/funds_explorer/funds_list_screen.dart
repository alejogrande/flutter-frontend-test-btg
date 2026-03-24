import 'package:btg_funds_app/dependency_injection/dependency_injection.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/widgets/investment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/funds_bloc.dart';
import 'bloc/funds_event.dart';
import 'bloc/funds_state.dart';

class FundsListScreen extends StatelessWidget {
  const FundsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double maxAppWidth = 1000.0;

    return BlocProvider(
      create: (context) => sl<FundsBloc>()..add(FetchFundsEvent()),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountSubscriptionError) {
            _showSnackBar(context, '❌ ${state.errorMessage}', Colors.redAccent);
          }
          if (state is AccountSubscriptionSuccess) {
            _showSnackBar(
              context,
              '✅ ${state.message}',
              const Color(0xFF002C5F),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text('Fondos Disponibles'),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.read<NavigationCubit>().goToHome(),
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: maxAppWidth),
              child: BlocBuilder<FundsBloc, FundsState>(
                builder: (context, state) {
                  if (state is FundsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FundsLoaded) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // FIX: Ajuste de breakpoints y ratios para evitar desbordes
                        int crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;

                        // En móvil (1 columna) damos más altura (ratio menor)
                        // En desktop (2 columnas) el ratio de 1.3 es más seguro que 1.5
                        double aspectRatio = constraints.maxWidth < 700
                            ? 1.35
                            : 1.3;

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio,
                              ),
                          itemCount: state.funds.length,
                          itemBuilder: (context, index) {
                            return _FundGridCard(
                              fund: state.funds[index],
                              onTap: () => _openInvestmentModal(
                                context,
                                state.funds[index],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  if (state is FundsError) {
                    return _buildErrorState(context, state.message);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<FundsBloc>().add(FetchFundsEvent()),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _FundGridCard extends StatelessWidget {
  final FundEntity fund;
  final VoidCallback onTap;

  const _FundGridCard({required this.fund, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    const int durationMonths = 12;
    final double estimatedReturn =
        fund.minimumAmount * (1 + (fund.annualRate / 100));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distribuye espacio sin Spacer
          children: [
            // Cabecera
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF002C5F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Categoría: ${fund.category}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            // Información técnica
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  'Tasa Anual',
                  '${(fund.annualRate * 100).toStringAsFixed(2)}%',
                ),
                _buildInfoColumn('Duración', '$durationMonths Meses'),
              ],
            ),

            // Inversión mínima
            _buildInfoColumn(
              'Inversión Mínima',
              currencyFormat.format(fund.minimumAmount),
              isBold: true,
            ),

            // Botón y Retorno
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002C5F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Invertir ahora',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Retorno estimado: ${currencyFormat.format(estimatedReturn)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(255, 55, 59, 55),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

void _openInvestmentModal(BuildContext context, FundEntity fund) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => InvestmentBottomSheet(
      fund: fund,
      onConfirm: (amount) {
        context.read<AccountBloc>().add(
          SubscribeToFundEvent(
            fundName: fund.name,
            amount: amount,
            minAmount: fund.minimumAmount,
            annualRate: fund.annualRate,
          ),
        );
      },
    ),
  );
}
