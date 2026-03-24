import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_state.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  // Guardamos el último saldo válido para evitar que la UI salte a 0 en errores o cargas
  double _lastValidBalance = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // Actualizamos el último saldo solo si el estado actual es válido
        // Como todas nuestras nuevas clases heredan de AccountState, 
        // todas tienen la propiedad .balance
        _lastValidBalance = state.balance;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 79, 145, 221), Color(0xFF001A3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo disponible',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${_formatCurrency(_lastValidBalance)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Agregamos un indicador de carga sutil si el estado es Subscribing
                  if (state is AccountSubscribing)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Disponible para nuevas inversiones',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}