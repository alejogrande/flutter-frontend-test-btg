import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';

class HistoryInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isProfit;
  final CrossAxisAlignment alignment;

  const HistoryInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.isProfit = false,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textLight, fontSize: 10),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isProfit && value != 'En proceso' 
                ? AppColors.success 
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}