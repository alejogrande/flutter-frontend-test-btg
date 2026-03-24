import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';

abstract class AccountRepository {
  double getBalance();
  Future<void> updateBalance(double newBalance);
  Future<void> saveTransaction(TransactionEntity transaction);
  List<TransactionEntity> getHistory();
  Future<void> unsubscribe(String fundName, double amount);

}