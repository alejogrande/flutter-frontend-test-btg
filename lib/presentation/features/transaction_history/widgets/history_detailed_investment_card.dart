import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailedInvestmentCard extends StatelessWidget {
  final String title;
  final String type;
  final String initialInvestment;
  final String profit;
  final String startDate;
  final String endDate;
  final String annualRate;
  final String totalGenerated;
  final bool isActive;

  const DetailedInvestmentCard({
    super.key,
    required this.title,
    required this.type,
    required this.initialInvestment,
    required this.profit,
    required this.startDate,
    required this.endDate,
    required this.annualRate,
    required this.totalGenerated,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(
          color: isActive
              ? const Color(0xFF002C5F).withOpacity(0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alineado arriba para el menú
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.blue.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isActive ? 'ACTIVA' : 'COMPLETADA',
                      style: TextStyle(
                        color: isActive
                            ? Colors.blue.shade800
                            : Colors.green.shade800,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // --- MENÚ DE 3 PUNTOS (Solo si está activa) ---
                  if (isActive)
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onSelected: (value) {
                        if (value == 'withdraw') {
                          _showWithdrawConfirmation(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'withdraw',
                          child: Row(
                            children: [
                              Icon(
                                Icons.outbound_outlined,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Desvincular / Retirar',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          _buildRow(
            'Inversión Inicial',
            initialInvestment,
            'Ganancia',
            profit,
            isProfit: true,
          ),
          const SizedBox(height: 8),
          _buildRow('Fecha Inicio', startDate, 'Fecha Fin', endDate),
          const SizedBox(height: 8),
          _buildRow(
            'Tasa Anual',
            annualRate,
            'Total Generado',
            totalGenerated,
            isBold: true,
          ),
        ],
      ),
    );
  }

  // Diálogo de confirmación para darle un toque "Senior"
  void _showWithdrawConfirmation(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirmar Retiro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas desvincularte de $title? El saldo será retornado a tu cuenta principal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF002C5F),
            ),
            onPressed: () {
              accountBloc.add(
                UnsubscribeFromFundEvent(
                  fundName: title,
                  // Limpiamos el string de la inversión inicial para volverlo double
                  amount:
                      double.tryParse(
                        initialInvestment.replaceAll(RegExp(r'[^\d]'), ''),
                      ) ??
                      0.0,
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('Confirmar Retiro'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label1,
    String val1,
    String label2,
    String val2, {
    bool isProfit = false,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
              Text(
                val1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label2,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
              Text(
                val2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: isProfit
                      ? Colors.green.shade700
                      : (isBold ? const Color(0xFF002C5F) : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
