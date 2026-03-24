import 'package:btg_funds_app/data/enums/transaction_type.dart';

class InvestmentSummary {
  final double totalInvested;
  final double averageRate;
  final double estimatedGains;
  final double totalRecovered;

  InvestmentSummary({
    required this.totalInvested,
    required this.averageRate,
    required this.estimatedGains,
    required this.totalRecovered,
  });
  factory InvestmentSummary.fromHistory(List<dynamic> history) {
    final subscriptions = history
        .where((t) => t.type == TransactionType.subscription)
        .toList();

    final totalInvested = subscriptions.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    final totalRecovered = history
        .where((t) => t.type == TransactionType.cancellation)
        .fold(0.0, (sum, item) => sum + item.amount);

    double averageRate = 0.0;
    if (subscriptions.isNotEmpty) {
      final sumRates = subscriptions.fold(
        0.0,
        (sum, item) => sum + item.annualRate,
      );
      averageRate = (sumRates / subscriptions.length) * 100;
    }

    return InvestmentSummary(
      totalInvested: totalInvested,
      totalRecovered: totalRecovered,
      averageRate: averageRate,
      estimatedGains: totalInvested * (averageRate / 100),
    );
  }
}
