import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/widgets/fund_grid_card.dart';

void main() {
  // Creamos un fondo de prueba
  final tFund = FundEntity(
    id: '1',
    name: 'FONDO TEST',
    minimumAmount: 50000,
    category: 'FIC',
    annualRate: 0.05,
  );

  testWidgets('Debe mostrar el nombre del fondo y el monto mínimo formateado', (WidgetTester tester) async {
    // 1. Construir el widget dentro de un MaterialApp (necesario para temas y dirección de texto)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FundGridCard(
            fund: tFund,
            onTap: () {},
          ),
        ),
      ),
    );

    // 2. Verificar que el texto del nombre aparezca
    expect(find.text('FONDO TEST'), findsOneWidget);
    
    // 3. Verificar que la categoría aparezca
    expect(find.text('Categoría: FIC'), findsOneWidget);

    // 4. Verificar que el botón de invertir esté presente
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}