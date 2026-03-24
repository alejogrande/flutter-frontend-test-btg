import 'package:btg_funds_app/core/utils/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('AppValidators Tests', () {
    test('Debe limpiar el string y convertirlo a double correctamente', () {
      final result = AppValidators.parseCurrencyToDouble('\$ 75.000');
      expect(result, 75000.0);
    });

    test('Debe retornar error si el monto es menor al mínimo', () {
      final error = AppValidators.validateInvestmentAmount(
        value: '10000',
        minAmount: 50000,
        minAmountFormatted: '\$ 50.000',
      );
      expect(error, contains('Mínimo requerido: \$ 50.000'));
    });

    test('Debe retornar null si el monto es válido', () {
      final error = AppValidators.validateInvestmentAmount(
        value: '100000',
        minAmount: 50000,
        minAmountFormatted: '\$ 50.000',
      );
      expect(error, isNull);
    });
  });
}