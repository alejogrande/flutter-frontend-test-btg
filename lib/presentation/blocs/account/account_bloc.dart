import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:btg_funds_app/domain/use_cases/unsubscribe_from_fund_use_case.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;
  final SubscribeToFundUseCase subscribeToFundUseCase;
  final UnsubscribeFromFundUseCase unsubscribeFromFundUseCase;

  AccountBloc({
    required this.repository,
    required this.subscribeToFundUseCase,
    required this.unsubscribeFromFundUseCase,
  }) : super(const AccountDataState(balance: 500000.0, history: [])) {
    // 1. Carga de información inicial
    on<LoadAccountInfoEvent>((event, emit) {
      emit(
        AccountDataState(
          balance: repository.getBalance(),
          history: repository.getHistory(),
        ),
      );
    });

    // 2. Suscripción (Vinculación)
    on<SubscribeToFundEvent>((event, emit) async {
      final currentBalance = repository.getBalance();
      final currentHistory = repository.getHistory();

      emit(
        AccountSubscribing(balance: currentBalance, history: currentHistory),
      );

      final error = await subscribeToFundUseCase(
        fundName: event.fundName,
        amount: event.amount,
        minAmount: event.minAmount,
        annualRate: event.annualRate,
      );

      if (error != null) {
        emit(
          AccountSubscriptionError(
            errorMessage: error,
            balance: currentBalance,
            history: currentHistory,
          ),
        );
        emit(
          AccountDataState(balance: currentBalance, history: currentHistory),
        );
      } else {
        emit(
          AccountSubscriptionSuccess(
            message: "¡Inversión exitosa en ${event.fundName}!",
            balance: currentBalance - event.amount,
            history: currentHistory,
          ),
        );
        add(LoadAccountInfoEvent());
      }
    });

    // 3. Desvincularse (Retirar capital)
    on<UnsubscribeFromFundEvent>((event, emit) async {
      final currentBalance = repository.getBalance();
      final currentHistory = repository.getHistory();

      // Emitimos estado de carga mientras procesamos el retiro
      emit(
        AccountSubscribing(balance: currentBalance, history: currentHistory),
      );

      // Invocamos el UseCase con los datos del evento
      final error = await unsubscribeFromFundUseCase(
        fundName: event.fundName,
        amount: event.amount,
      );

      if (error != null) {
        emit(
          AccountSubscriptionError(
            errorMessage: error,
            balance: currentBalance,
            history: currentHistory,
          ),
        );
        emit(
          AccountDataState(balance: currentBalance, history: currentHistory),
        );
      } else {
        // ÉXITO: El dinero vuelve al balance
        emit(
          AccountSubscriptionSuccess(
            message: "Retiro exitoso",
            balance: currentBalance + event.amount,
            history: repository
                .getHistory(), // Pasa la lista actualizada directamente
          ),
        );
        add(LoadAccountInfoEvent());

      }
    });
  }
}
