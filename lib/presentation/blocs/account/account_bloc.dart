import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;
  final SubscribeToFundUseCase subscribeToFundUseCase;

  AccountBloc({required this.repository, required this.subscribeToFundUseCase})
      : super(const AccountDataState(balance: 500000.0, history: [])) {
    
    // Manejo de carga de información
    on<LoadAccountInfoEvent>((event, emit) {
      emit(AccountDataState(
        balance: repository.getBalance(),
        history: repository.getHistory(),
      ));
    });

    // Manejo de suscripción a fondos
    on<SubscribeToFundEvent>((event, emit) async {
      final currentBalance = repository.getBalance();
      final currentHistory = repository.getHistory();

      // 1. Emitimos carga manteniendo los datos actuales
      emit(AccountSubscribing(balance: currentBalance, history: currentHistory));

      final error = await subscribeToFundUseCase(
        fundName: event.fundName,
        amount: event.amount,
        minAmount: event.minAmount,
      );

      if (error != null) {
        // 2. ERROR: Emitimos el estado de error
        emit(AccountSubscriptionError(
          errorMessage: error,
          balance: currentBalance,
          history: currentHistory,
        ));
        
        // 3. Importante: Regresamos al estado de datos para que la UI se estabilice
        emit(AccountDataState(balance: currentBalance, history: currentHistory));
      } else {
        // 4. ÉXITO: Emitimos éxito
        emit(AccountSubscriptionSuccess(
          message: "¡Inversión exitosa en ${event.fundName}!",
          balance: currentBalance - event.amount, // Balance estimado mientras recarga
          history: currentHistory,
        ));

        // 5. Recargamos la data real desde el repositorio
        add( LoadAccountInfoEvent());
      }
    });
  }
}