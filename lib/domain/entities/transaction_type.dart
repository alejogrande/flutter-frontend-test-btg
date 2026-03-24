enum TransactionType { subscription, cancellation }

class TransactionEntity {
  final String id;
  final String fundName;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionEntity({
    required this.id,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.type,
  });
}