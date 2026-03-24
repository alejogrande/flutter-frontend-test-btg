import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/data/enums/transaction_type.dart'; // Asegúrate de importar tu enum

class AccountRepositoryImpl implements AccountRepository {
  // Datos iniciales requeridos por la prueba
  double _currentBalance = 500000.0;
  final List<TransactionEntity> _history = [];

  @override
  double getBalance() => _currentBalance;

  @override
  Future<void> updateBalance(double newBalance) async {
    _currentBalance = newBalance;
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    _history.insert(0, transaction);
  }

  @override
  List<TransactionEntity> getHistory() => List.unmodifiable(_history);

  @override
  Future<void> unsubscribe(String fundName, double amount) async {
    final index = _history.indexWhere(
      (t) => t.fundName == fundName && t.type == TransactionType.subscription,
    );

    if (index == -1) throw Exception("Inversión no encontrada");

    // 1. REEMPLAZO DE CARD (Ya te funciona)
    _history[index] = TransactionEntity(
      id: _history[index].id,
      fundName: fundName,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.cancellation,
      annualRate: 0.0,
    );

    _currentBalance += amount;
  }
}
