import 'package:btg_funds_app/core/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/core/theme/app_colors.dart';
import 'package:btg_funds_app/core/theme/app_design.dart';
import 'package:btg_funds_app/core/utils/formatters.dart';

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


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHandle(),
          AppSpacing.vmd,
          _buildHeader(),
          AppSpacing.vmd,
          _buildAmountInput(),
          AppSpacing.vlg,
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: AppRadius.roundedSm,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Invertir en ${widget.fund.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.vsm,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: AppRadius.roundedSm,
          ),
          child: Text(
            'Monto mínimo: ${AppFormatters.toCurrency(widget.fund.minimumAmount)}',
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return TextField(
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
        border: OutlineInputBorder(borderRadius: AppRadius.roundedMd),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
      onChanged: (_) {
        if (_errorMessage != null) setState(() => _errorMessage = null);
      },
    );
  }

Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        // 1. Limpiamos el valor usando el validador externo
        final double amount = AppValidators.parseCurrencyToDouble(_amountController.text);
        
        // 2. Ejecutamos la lógica de validación
        final String? error = AppValidators.validateInvestmentAmount(
          value: _amountController.text,
          minAmount: widget.fund.minimumAmount,
          minAmountFormatted: AppFormatters.toCurrency(widget.fund.minimumAmount),
        );

        if (error != null) {
          setState(() => _errorMessage = error);
          return;
        }

        // 3. Si todo está ok, cerramos el bottom sheet y notificamos el monto limpio
        Navigator.pop(context);
        widget.onConfirm(amount);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
        ),
      ),
      child: const Text(
        'Confirmar Inversión',
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}