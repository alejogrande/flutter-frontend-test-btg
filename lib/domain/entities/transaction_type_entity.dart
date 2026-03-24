import 'package:btg_funds_app/data/enums/transaction_type.dart';

class TransactionEntity {
  final String id;
  final String fundName;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final double annualRate; 
  final DateTime? endDate; 

  TransactionEntity({
    required this.id,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.type,
    this.annualRate = 0.05,
    this.endDate,
  });

  bool get isActive => type == TransactionType.subscription && endDate == null;
}