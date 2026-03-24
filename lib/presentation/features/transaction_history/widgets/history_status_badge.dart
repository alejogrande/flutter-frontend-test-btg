import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';

class HistoryStatusBadge extends StatelessWidget {
  final bool isActive;

  const HistoryStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive ? const Color(0xFFE3F2FD) : const Color(0xFFE8F5E9);
    final textColor = isActive ? const Color(0xFF1976D2) : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm, 
        vertical: AppSpacing.xs
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.roundedSm,
      ),
      child: Text(
        isActive ? 'ACTIVA' : 'COMPLETADA',
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}