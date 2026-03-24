import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const double maxContentWidth = 1300;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF002C5F)),
          label: const Text('Volver', style: TextStyle(color: Color(0xFF002C5F))),
        ),
        title: Column(
          children: [
            const Text('Histórico de Inversiones', 
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Inversiones completadas y finalizadas', 
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- FILA DE 4 CARDS (Adaptativa) ---
               LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 600;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      children: [
                      SmallInfoCard(title: 'Total invertido', value: '\$250.000', isWide: isWide),
                      SmallInfoCard(title: 'Total recuperado', value: '\$50.000', isWide: isWide),
                      SmallInfoCard(title: 'Ganancias totales', value: '\$12.500', isWide: isWide),
                      SmallInfoCard(title: 'Retorno promedio', value: '8.5%', isWide: isWide),
                    ],
                  );
                }),

                const SizedBox(height: 32),

                // --- SECCIÓN DE LISTADO ---
                const Text(
                  'Inversiones',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '4 inversiones activas y finalizadas',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                
                const SizedBox(height: 16),

                // Ejemplo de Card de Inversión Histórica
                const _DetailedInvestmentCard(
                  title: 'FPV_BTG_PACTUAL_RECAUDADORA',
                  type: 'Fondo Voluntario de Pensión',
                  initialInvestment: '\$50.000',
                  profit: '+\$2.800',
                  startDate: '01/01/2026',
                  endDate: 'Activa',
                  annualRate: '5.60%',
                  totalGenerated: '\$52.800',
                  isActive: true,
                ),
                const _DetailedInvestmentCard(
                  title: 'FIC DEUDAPRIVADA',
                  type: 'Fondo de Inversión Colectiva',
                  initialInvestment: '\$100.000',
                  profit: '+\$5.200',
                  startDate: '10/12/2025',
                  endDate: '10/03/2026',
                  annualRate: '5.20%',
                  totalGenerated: '\$105.200',
                  isActive: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para las estadísticas del historial
class _HistoryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isWide;
  const _HistoryStatCard({required this.title, required this.value, required this.isWide});

  @override
  Widget build(BuildContext context) {
    double width = isWide ? (MediaQuery.of(context).size.width / 4) - 25 : (MediaQuery.of(context).size.width / 2) - 30;
    return Container(
      width: width.clamp(140, 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 10), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// Card detallada de la inversión
class _DetailedInvestmentCard extends StatelessWidget {
  final String title;
  final String type;
  final String initialInvestment;
  final String profit;
  final String startDate;
  final String endDate;
  final String annualRate;
  final String totalGenerated;
  final bool isActive;

  const _DetailedInvestmentCard({
    required this.title, required this.type, required this.initialInvestment,
    required this.profit, required this.startDate, required this.endDate,
    required this.annualRate, required this.totalGenerated, required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? const Color(0xFF002C5F).withOpacity(0.3) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(type, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'ACTIVA' : 'COMPLETADA',
                  style: TextStyle(
                    color: isActive ? Colors.blue.shade800 : Colors.green.shade800,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildRow('Inversión Inicial', initialInvestment, 'Ganancia', profit, isProfit: true),
          const SizedBox(height: 8),
          _buildRow('Fecha Inicio', startDate, 'Fecha Fin', endDate),
          const SizedBox(height: 8),
          _buildRow('Tasa Anual', annualRate, 'Total Generado', totalGenerated, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label1, String val1, String label2, String val2, {bool isProfit = false, bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label1, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
            Text(val1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(label2, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
            Text(
              val2, 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isProfit ? Colors.green.shade700 : (isBold ? const Color(0xFF002C5F) : Colors.black),
              )
            ),
          ]),
        ),
      ],
    );
  }
}