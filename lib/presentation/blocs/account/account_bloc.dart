import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;
  final SubscribeToFundUseCase subscribeToFundUseCase;

  AccountBloc({required this.repository, required this.subscribeToFundUseCase})
    : super(AccountState(balance: 500000.0, history: [])) {
    on<LoadAccountInfoEvent>((event, emit) {
      emit(
        AccountState(
          balance: repository.getBalance(),
          history: repository.getHistory(),
        ),
      );
    });

    on<SubscribeToFundEvent>((event, emit) async {
      emit(
        AccountState(
          balance: state.balance,
          history: state.history,
          isSubscribing: true,
        ),
      );

      final error = await subscribeToFundUseCase(
        fundName: event.fundName,
        amount: event.amount,
        minAmount: event.minAmount,
      );

      if (error != null) {
        emit(
          AccountState(
            balance: state.balance,
            history: state.history,
            errorMessage: error,
          ),
        );
      } else {
        add(LoadAccountInfoEvent()); // Recargamos datos tras éxito
      }
    });
  }
}
