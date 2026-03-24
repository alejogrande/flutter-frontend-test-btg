import 'package:btg_funds_app/presentation/features/transaction_history/widgets/history_emty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/domain/entities/investment_summary.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/widgets/custom_app_bar.dart';
import 'widgets/history_stats_header.dart';
import 'widgets/history_detailed_investment_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Histórico de Inversiones',
        showBackButton: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final summary = InvestmentSummary.fromHistory(state.history);
          final transactions = state.history;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HistoryStatsHeader(summary: summary),
                    AppSpacing.vxl,
                    const Text(
                      'Inversiones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Text(
                      '${transactions.length} movimientos registrados',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    AppSpacing.vmd,
                    if (transactions.isEmpty)
                      const HistoryEmptyState()
                    else
                      ...transactions.map((t) => DetailedInvestmentCard(transaction: t)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}