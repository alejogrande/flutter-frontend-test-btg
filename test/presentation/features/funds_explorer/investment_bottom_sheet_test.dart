import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/widgets/investment_bottom_sheet.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';

void main() {
  final tFund = FundEntity(
    id: '1',
    name: 'Fondo Test',
    minimumAmount: 50000,
    category: 'FIC',
    annualRate: 0.05,
  );

  testWidgets('Debe mostrar error si el monto ingresado es menor al mínimo', (tester) async {
    double? capturedAmount;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvestmentBottomSheet(
            fund: tFund,
            onConfirm: (amount) => capturedAmount = amount,
          ),
        ),
      ),
    );

    // 1. Encontrar el TextField e ingresar un valor bajo (10.000)
    await tester.enterText(find.byType(TextField), '10000');
    
    // 2. Tap en el botón de confirmar
    await tester.tap(find.text('Confirmar Inversión'));
    await tester.pump(); // Re-renderizar para mostrar el error

    // 3. Verificar que aparezca el mensaje de error y NO se llame a onConfirm
    expect(find.textContaining('Mínimo requerido'), findsOneWidget);
    expect(capturedAmount, isNull);
  });

  testWidgets('Debe llamar a onConfirm con el monto correcto si es válido', (tester) async {
    double? capturedAmount;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvestmentBottomSheet(
            fund: tFund,
            onConfirm: (amount) => capturedAmount = amount,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '60000');
    await tester.tap(find.text('Confirmar Inversión'));
    
    // Aquí no necesitamos pump() porque el Navigator.pop sucede inmediatamente
    expect(capturedAmount, 60000.0);
  });
}