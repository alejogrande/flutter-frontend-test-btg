import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Text(
          "No hay movimientos registrados",
          style: TextStyle(color: AppColors.textLight),
        ),
      ),
    );
  }
}