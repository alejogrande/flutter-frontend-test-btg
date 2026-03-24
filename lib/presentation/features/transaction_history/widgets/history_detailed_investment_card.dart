import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:btg_funds_app/data/enums/transaction_type.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'history_status_badge.dart';
import 'history_info_item.dart';

class DetailedInvestmentCard extends StatelessWidget {
  final dynamic transaction;

  const DetailedInvestmentCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isSub = transaction.type == TransactionType.subscription;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isSub ? AppColors.primaryBlue.withValues(alpha: 0.1) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderInfo(isSub),
              Row(
                children: [
                  HistoryStatusBadge(isActive: isSub),
                  if (isSub) _buildMenu(context),
                ],
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          _buildDataGrid(isSub),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(bool isSub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction.fundName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          isSub ? 'Fondo de Inversión' : 'Retiro de Capital',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textLight),
      onSelected: (value) => _showConfirmDialog(context),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'withdraw',
          child: Text('Desvincular / Retirar', style: TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildDataGrid(bool isSub) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HistoryInfoItem(
                label: 'Inversión', 
                value: AppFormatters.toCurrency(transaction.amount)
              ),
            ),
            Expanded(
              child: HistoryInfoItem(
                label: 'Ganancia', 
                value: isSub ? 'En proceso' : 'Finalizado',
                isProfit: true,
                alignment: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),
        AppSpacing.vsm,
        Row(
          children: [
            Expanded(
              child: HistoryInfoItem(
                label: 'Fecha', 
                value: AppFormatters.formatDate(transaction.date)
              ),
            ),
            Expanded(
              child: HistoryInfoItem(
                label: 'Tasa', 
                value: AppFormatters.toPercentage(transaction.annualRate * 100),
                alignment: CrossAxisAlignment.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Retiro'),
        content: Text('¿Deseas retirar fondos de ${transaction.fundName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AccountBloc>().add(UnsubscribeFromFundEvent(
                fundName: transaction.fundName,
                amount: transaction.amount,
              ));
              Navigator.pop(dialogContext);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}