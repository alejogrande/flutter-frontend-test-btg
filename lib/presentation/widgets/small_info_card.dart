import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';

class SmallInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isWide;

  const SmallInfoCard({
    super.key, 
    required this.title, 
    required this.value, 
    required this.isWide
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md + 4,
        horizontal: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary, 
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vsm,
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: AppColors.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return isWide ? Expanded(child: card) : card;
  }
}