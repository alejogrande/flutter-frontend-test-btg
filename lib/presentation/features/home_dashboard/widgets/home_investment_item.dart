import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class InvestmentItem extends StatelessWidget {
  final String name;
  final String date;
  final String total;
  final String invested;
  final double profit;
  final double profitPercent;

  const InvestmentItem({super.key, required this.name, required this.date, required this.total, required this.invested, required this.profit, required this.profitPercent});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Fondo de Inversión',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: AppColors.textLight, fontSize: 10),
                ),
              ],
            ),
          ),
          AppSpacing.hsm,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                total,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                'Inv: $invested',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                '${profitPercent.toStringAsFixed(2)}% (+${AppFormatters.toCurrency(profit)})',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
