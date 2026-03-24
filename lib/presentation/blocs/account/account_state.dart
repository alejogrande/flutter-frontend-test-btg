import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  final double balance;
  final List<TransactionEntity> history;

  const AccountState({required this.balance, required this.history});

  @override
  List<Object?> get props => [balance, history];
}

// 1. Estado de Reposo / Datos Cargados
class AccountDataState extends AccountState {
  const AccountDataState({required super.balance, required super.history});
}

// 2. Estado de Carga (Suscripción en curso)
class AccountSubscribing extends AccountState {
  const AccountSubscribing({required super.balance, required super.history});
}

// 3. Estado de ERROR (Clase específica para el SnackBar)
class AccountSubscriptionError extends AccountState {
  final String errorMessage;
  
  const AccountSubscriptionError({
    required this.errorMessage, 
    required super.balance, 
    required super.history
  });

  @override
  List<Object?> get props => [errorMessage, balance, history];
}

// 4. Estado de ÉXITO (Clase específica para el SnackBar)
class AccountSubscriptionSuccess extends AccountState {
  final String message;

  const AccountSubscriptionSuccess({
    required this.message, 
    required super.balance, 
    required super.history
  });

  @override
  List<Object?> get props => [message, balance, history];
}