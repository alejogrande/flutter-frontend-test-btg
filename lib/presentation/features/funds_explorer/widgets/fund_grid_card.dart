import 'package:flutter/material.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';

class FundGridCard extends StatelessWidget {
  final FundEntity fund;
  final VoidCallback onTap;

  const FundGridCard({super.key, required this.fund, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double estimatedReturn = fund.minimumAmount * (1 + (fund.annualRate / 100));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildTechnicalInfo(),
            _buildMinInvestment(),
            _buildActionSection(estimatedReturn),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fund.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryBlue,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Categoría: ${fund.category}',
          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildTechnicalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InfoColumn(
          label: 'Tasa Anual',
          value: AppFormatters.toPercentage(fund.annualRate * 100),
        ),
        const _InfoColumn(label: 'Duración', value: '12 Meses'),
      ],
    );
  }

  Widget _buildMinInvestment() {
    return _InfoColumn(
      label: 'Inversión Mínima',
      value: AppFormatters.toCurrency(fund.minimumAmount),
      isBold: true,
    );
  }

  Widget _buildActionSection(double estimatedReturn) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedSm),
            ),
            child: const Text(
              'Invertir ahora',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AppSpacing.vxs,
        Text(
          'Retorno estimado: ${AppFormatters.toCurrency(estimatedReturn)}',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoColumn({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}