import 'package:btg_funds_app/data/enums/transaction_type.dart';

class TransactionEntity {
  final String id;
  final String fundName;
  final double amount;
  final DateTime date;
  final TransactionType type;
  // Campos nuevos para mayor profesionalismo:
  final double annualRate; // Para mostrar rentabilidad
  final DateTime? endDate; // Nulo si la inversión sigue activa

  TransactionEntity({
    required this.id,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.type,
    this.annualRate = 0.05, // Valor por defecto o real del fondo
    this.endDate,
  });

  // Getter útil para la UI
  bool get isActive => type == TransactionType.subscription && endDate == null;
}