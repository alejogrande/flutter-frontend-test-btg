import 'package:btg_funds_app/domain/entities/transaction_type.dart';

import '../repositories/account_repository.dart';
import 'package:uuid/uuid.dart'; 

class SubscribeToFundUseCase {
  final AccountRepository repository;

  SubscribeToFundUseCase({required this.repository});

  Future<String?> call({
    required String fundName,
    required double amount,
    required double minAmount,
  }) async {
    final currentBalance = repository.getBalance();

    // Regla 1: Monto mínimo del fondo
    if (amount < minAmount) {
      return "No es posible vincularse al fondo $fundName, el monto mínimo es \$$minAmount";
    }

    // Regla 2: Saldo disponible
    if (amount > currentBalance) {
      return "No tiene saldo disponible para vincularse al fondo $fundName";
    }

    // Si todo está bien, procedemos
    final newBalance = currentBalance - amount;
    await repository.updateBalance(newBalance);
    
    final transaction = TransactionEntity(
      id: const Uuid().v4(), // Genera un ID único
      fundName: fundName,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.subscription,
    );

    await repository.saveTransaction(transaction);
    
    return null; // Éxito (sin mensaje de error)
  }
}