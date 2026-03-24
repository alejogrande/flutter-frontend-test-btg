import 'package:btg_funds_app/domain/entities/transaction_type.dart';

class AccountState {
  final double balance;
  final List<TransactionEntity> history;
  final String? errorMessage;
  final bool isSubscribing;

  AccountState({
    required this.balance,
    required this.history,
    this.errorMessage,
    this.isSubscribing = false,
  });
}
