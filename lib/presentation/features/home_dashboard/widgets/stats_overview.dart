import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:btg_funds_app/domain/entities/investment_summary.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_action_card.dart';
import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget interno para organizar las 3 cards de info superior
class StatsOverview extends StatelessWidget {
  final InvestmentSummary summary;

  const StatsOverview({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > AppSpacing.mobileBreakpoint;
        
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            SmallInfoCard(
              title: 'Total invertido',
              value: AppFormatters.toCurrency(summary.totalInvested),
              isWide: isWide,
            ),
            isWide ? AppSpacing.hsm : AppSpacing.vsm,
            SmallInfoCard(
              title: 'Rentabilidad',
              value: AppFormatters.toPercentage(summary.averageRate),
              isWide: isWide,
            ),
            isWide ? AppSpacing.hsm : AppSpacing.vsm,
            SmallInfoCard(
              title: 'Ganancias',
              value: AppFormatters.toCurrency(summary.estimatedGains),
              isWide: isWide,
            ),
          ],
        );
      },
    );
  }
}

/// Widget interno para los botones de navegación
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});


  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavigationCubit>();
    
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        HomeActionButton(
          title: 'Inversiones disponibles',
          subtitle: 'Explora nuevas inversiones',
          icon: Icons.auto_graph_rounded,
          iconContainerColor: AppColors.info,
          backgroundColor: const Color(0xFFF3E5F5),
          onTap: () => nav.goToExplorer(),
        ),
        HomeActionButton(
          title: 'Histórico de inversiones',
          subtitle: 'Revisa tus inversiones pasadas',
          icon: Icons.history_rounded,
          iconContainerColor: AppColors.success,
          backgroundColor: AppColors.surface,
          onTap: () => nav.goToHistory(),
        ),
      ],
    );
  }
}