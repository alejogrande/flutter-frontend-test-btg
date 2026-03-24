import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/stats_overview.dart';
import 'package:btg_funds_app/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core & Theme
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';

// Domain
import 'package:btg_funds_app/domain/entities/investment_summary.dart';

// BLoC
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';

// Widgets
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_active_investments_card.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_balance_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Portal de Inversiones'),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final summary = InvestmentSummary.fromHistory(state.history);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BalanceCard(),
                    AppSpacing.vlg,
                    StatsOverview(summary: summary),
                    AppSpacing.vxl,
                    const QuickActionsSection(),
                    AppSpacing.vxl,
                    const ActiveInvestmentsCard(),
                    AppSpacing.vlg,
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
