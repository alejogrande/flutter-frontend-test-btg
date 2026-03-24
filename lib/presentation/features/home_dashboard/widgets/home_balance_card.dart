import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart'; 
import 'package:btg_funds_app/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg), 
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentBlue, AppColors.deepNavy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.roundedXl, 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo disponible',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              AppSpacing.vsm,
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, 
                             color: Colors.white, size: 28),
                  AppSpacing.hmd,
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppFormatters.toCurrency(state.balance), 
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (state is AccountSubscribing)
                    const _LoadingIndicator(),
                ],
              ),
              AppSpacing.vmd,
              const Text(
                'Disponible para nuevas inversiones',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20, height: 20,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    );
  }
}