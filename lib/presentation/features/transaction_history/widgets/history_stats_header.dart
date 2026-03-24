import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:btg_funds_app/domain/entities/investment_summary.dart';
import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';

class HistoryStatsHeader extends StatelessWidget {
  final InvestmentSummary summary;

  const HistoryStatsHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 600;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            SmallInfoCard(
              title: 'Invertido',
              value: AppFormatters.toCurrency(summary.totalInvested),
              isWide: isWide,
            ),
            isWide ? AppSpacing.hsm : AppSpacing.vsm,
            SmallInfoCard(
              title: 'Recuperado',
              value: AppFormatters.toCurrency(summary.totalRecovered ?? 0),
              isWide: isWide,
            ),
            isWide ? AppSpacing.hsm : AppSpacing.vsm,
            SmallInfoCard(
              title: 'Retorno Promedio',
              value: AppFormatters.toPercentage(summary.averageRate),
              isWide: isWide,
            ),
          ],
        );
      },
    );
  }
}