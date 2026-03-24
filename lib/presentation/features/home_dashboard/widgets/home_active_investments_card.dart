import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_investment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';

class ActiveInvestmentsCard extends StatelessWidget {
  const ActiveInvestmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // Usamos el getter isActive que definimos en tu Entity
        final activeSubscriptions = state.history
            .where((t) => t.isActive)
            .toList();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.roundedXl,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mis Inversiones Actuales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Tienes ${activeSubscriptions.length} inversiones activas',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              AppSpacing.vmd,

              if (activeSubscriptions.isEmpty)
                const _EmptyInvestments()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeSubscriptions.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final t = activeSubscriptions[index];

                    final profitAmount = t.amount * t.annualRate;
                    final totalValue = t.amount + profitAmount;

                    return InvestmentItem(
                      name: t.fundName,
                      date: AppFormatters.formatDate(
                        t.date,
                      ), 
                      total: AppFormatters.toCurrency(totalValue),
                      invested: AppFormatters.toCurrency(t.amount),
                      profit: profitAmount,
                      profitPercent: t.annualRate * 100,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyInvestments extends StatelessWidget {
  const _EmptyInvestments();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Text(
          "No tienes inversiones vigentes",
          style: TextStyle(color: AppColors.textLight),
        ),
      ),
    );
  }
}

