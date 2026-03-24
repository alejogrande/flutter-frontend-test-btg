import 'package:btg_funds_app/data/enums/transaction_type.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class _InvestmentItem extends StatelessWidget {
  final String name;
  final String type;
  final String date;
  final String total;
  final String invested;
  final String profit;

  const _InvestmentItem({
    required this.name,
    required this.type,
    required this.date,
    required this.total,
    required this.invested,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LADO IZQUIERDO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(type, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                Text(date, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // LADO DERECHO
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                total,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF002C5F)),
              ),
              Text('Inv: $invested', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
              Text(
                profit,
                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActiveInvestmentsCard extends StatelessWidget {
  const ActiveInvestmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // Filtramos solo las suscripciones activas
        final activeSubscriptions = state.history
            .where((t) => t.type == TransactionType.subscription)
            .toList();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mis Inversiones Actuales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Tienes ${activeSubscriptions.length} inversiones activas',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 10),
              
              if (activeSubscriptions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("No tienes inversiones vigentes")),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeSubscriptions.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final t = activeSubscriptions[index];
                    
                    // Cálculos para la card
                    final double profitAmount = t.amount * t.annualRate;
                    final double totalValue = t.amount + profitAmount;
                    final String formattedDate = DateFormat('dd MMM yyyy', 'es_CO').format(t.date);

                    return _InvestmentItem(
                      name: t.fundName,
                      type: 'Fondo de Inversión',
                      date: formattedDate,
                      total: '\$${_format(totalValue)}',
                      invested: '\$${_format(t.amount)}',
                      profit: '${(t.annualRate * 100).toStringAsFixed(2)}% (+\$${_format(profitAmount)})',
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _format(double val) => val
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}