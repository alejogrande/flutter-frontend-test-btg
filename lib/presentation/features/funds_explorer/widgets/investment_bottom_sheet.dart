import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';

class InvestmentBottomSheet extends StatefulWidget {
  final FundEntity fund;
  final Function(double amount) onConfirm;

  const InvestmentBottomSheet({
    super.key,
    required this.fund,
    required this.onConfirm,
  });

  @override
  State<InvestmentBottomSheet> createState() => _InvestmentBottomSheetState();
}

class _InvestmentBottomSheetState extends State<InvestmentBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAndConfirm() {
    final String cleanValue = _amountController.text.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    final double? amount = double.tryParse(cleanValue);

    if (amount == null || amount <= 0) {
      setState(() => _errorMessage = "Ingresa un monto válido");
      return;
    }

    if (amount < widget.fund.minimumAmount) {
      setState(
        () => _errorMessage =
            "El monto mínimo es \$${widget.fund.minimumAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
      );
      return;
    }

    // --- EL CAMBIO CRÍTICO ---

    // 1. Cerramos el modal primero para liberar el contexto
    Navigator.pop(context);

    // 2. Ejecutamos el callback.
    // Ahora 'onConfirm' se ejecutará en el contexto de la FundsListScreen
    widget.onConfirm(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        // Este padding es vital para que el teclado no tape el botón
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicador visual de arrastre (Handle)
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Invertir en ${widget.fund.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF002C5F),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Monto mínimo: \$${widget.fund.minimumAmount.toInt()}',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '0',
              prefixText: '\$ ',
              errorText: _errorMessage,
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF002C5F),
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (_errorMessage != null) setState(() => _errorMessage = null);
            },
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _validateAndConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF002C5F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Confirmar Inversión',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
