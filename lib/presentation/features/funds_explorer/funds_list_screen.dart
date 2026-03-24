import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/dependency_injection/dependency_injection.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:btg_funds_app/presentation/widgets/custom_app_bar.dart';

import 'bloc/funds_bloc.dart';
import 'bloc/funds_event.dart';
import 'bloc/funds_state.dart';
import 'widgets/fund_grid_card.dart';
import 'widgets/funds_error_view.dart';
import 'widgets/investment_bottom_sheet.dart';

class FundsListScreen extends StatelessWidget {
  const FundsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (context) {
  final bloc = sl<FundsBloc>();
  bloc.add(FetchFundsEvent());
  return bloc; // Aquí garantizamos que devolvemos el Bloc
},
      child: BlocListener<AccountBloc, AccountState>(
        listener: _handleAccountState,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Fondos Disponibles',
            showBackButton: true,
            onBack: () => context.read<NavigationCubit>().goToHome(),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: BlocBuilder<FundsBloc, FundsState>(
                builder: (context, state) {
                  if (state is FundsLoading) return const Center(child: CircularProgressIndicator());
                  
                  if (state is FundsLoaded) return _buildGrid(state.funds);

                  if (state is FundsError) {
                    return FundsErrorView(
                      message: state.message,
                      onRetry: () => context.read<FundsBloc>().add(FetchFundsEvent()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<dynamic> funds) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;
        double aspectRatio = constraints.maxWidth < 700 ? 2.2 : 1.6;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: aspectRatio,
          ),
          itemCount: funds.length,
          itemBuilder: (context, index) => FundGridCard(
            fund: funds[index],
            onTap: () => _openInvestmentModal(context, funds[index]),
          ),
        );
      },
    );
  }

  void _handleAccountState(BuildContext context, AccountState state) {
    if (state is AccountSubscriptionError) {
      _showSnackBar(context, '❌ ${state.errorMessage}', Colors.redAccent);
    }
    if (state is AccountSubscriptionSuccess) {
      _showSnackBar(context, '✅ ${state.message}', AppColors.primaryBlue);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  void _openInvestmentModal(BuildContext context, dynamic fund) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bCtx) => InvestmentBottomSheet(
        fund: fund,
        onConfirm: (amount) => context.read<AccountBloc>().add(
          SubscribeToFundEvent(
            fundName: fund.name,
            amount: amount,
            minAmount: fund.minimumAmount,
            annualRate: fund.annualRate,
          ),
        ),
      ),
    );
  }
}