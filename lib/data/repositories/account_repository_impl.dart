import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';

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
    _history.insert(0, transaction); // Insertamos al inicio para ver lo más reciente primero
  }

  @override
  List<TransactionEntity> getHistory() => List.unmodifiable(_history);
}