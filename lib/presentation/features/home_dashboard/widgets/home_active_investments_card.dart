import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LADO IZQUIERDO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(type, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(date, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ],
            ),
          ),
          // LADO DERECHO
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF002C5F))),
              Text('Inv: $invested', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(
                profit,
                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w500),
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
            'Tienes 2 inversiones activas', // Aquí luego inyectaremos el largo de la lista
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const Divider(),
          // LISTA DE ITEMS (Mockup inicial)
          const _InvestmentItem(
            name: 'FPV_BTG_PACTUAL_RECAUDADORA',
            type: 'Fondo Voluntario de Pensión',
            date: '20 Mar 2026',
            total: '\$52.800',
            invested: '\$50.000',
            profit: '5.60% (+\$2.800)',
          ),
          const Divider(),
          const _InvestmentItem(
            name: 'DEUDAPRIVADA',
            type: 'Fondo de Inversión Colectiva',
            date: '15 Mar 2026',
            total: '\$105.200',
            invested: '\$100.000',
            profit: '5.20% (+\$5.200)',
          ),
          const Divider(),
          
          const SizedBox(height: 10),
          
        ],
      ),
    );
  }
}