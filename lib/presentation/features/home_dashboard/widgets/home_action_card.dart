import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:flutter/material.dart';

class HomeActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconContainerColor;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const HomeActionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconContainerColor,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usamos el sistema de espaciado para el cálculo de ancho
        final double width = constraints.maxWidth > 500 
            ? (constraints.maxWidth / 2) - (AppSpacing.sm) 
            : double.infinity;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.surface,
              borderRadius: AppRadius.roundedLg,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _IconContainer(icon: icon, color: iconContainerColor),
                AppSpacing.hmd,
                Expanded(
                  child: _ButtonText(title: title, subtitle: subtitle),
                ),
                Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Sub-widgets privados para mantener el build limpio
class _IconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconContainer({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.roundedMd,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _ButtonText extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ButtonText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryBlue,
          ),
        ),
        AppSpacing.vxs,
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}