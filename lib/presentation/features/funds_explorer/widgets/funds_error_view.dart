import 'package:flutter/material.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';

class FundsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const FundsErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          AppSpacing.vmd,
          Text(message, textAlign: TextAlign.center),
          AppSpacing.vmd,
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}