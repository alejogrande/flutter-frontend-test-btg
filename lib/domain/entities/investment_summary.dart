
import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';

class InvestmentSummary {
  final double totalInvested;
  final double averageRate;
  final double estimatedGains;

  InvestmentSummary({
    required this.totalInvested,
    required this.averageRate,
    required this.estimatedGains,
  });

  // Este "factory" procesa el historial que viene del AccountState
  factory InvestmentSummary.fromHistory(List<TransactionEntity> history) {
    // Filtramos solo las que están marcadas como suscripción activa
    final activeInvs = history.where((t) => t.isActive).toList();

    if (activeInvs.isEmpty) {
      return InvestmentSummary(totalInvested: 0, averageRate: 0, estimatedGains: 0);
    }

    // Sumamos los montos de las inversiones activas
    final total = activeInvs.fold(0.0, (sum, t) => sum + t.amount);
    
    // Sacamos el promedio de rentabilidad de lo que el usuario tiene invertido
    final sumRates = activeInvs.fold(0.0, (sum, t) => sum + t.annualRate);
    final avgRate = (sumRates / activeInvs.length);
    
    return InvestmentSummary(
      totalInvested: total,
      averageRate: avgRate * 100, // Lo pasamos a formato porcentaje (ej: 5.2)
      estimatedGains: total * avgRate,
    );
  }
}