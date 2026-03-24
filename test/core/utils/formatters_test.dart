import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importante para fechas
import 'package:btg_funds_app/core/utils/formatters.dart';

void main() {
  // setUpAll se ejecuta una sola vez antes de todos los tests del grupo
  setUpAll(() async {
    // Inicializa los datos de formato para Colombia (es_CO)
    await initializeDateFormatting('es_CO', null);
  });

  group('AppFormatters Tests', () {
    
    test('toCurrency debe formatear a moneda colombiana sin decimales', () {
      const double value = 75000.0;
      final result = AppFormatters.toCurrency(value);
      
      // En es_CO el formato suele ser $ 75.000 o $75.000 dependiendo de la versión de intl
      // Usamos contains para asegurar que los elementos clave estén ahí
      expect(result, contains('\$'));
      expect(result, contains('75'));
      expect(result, contains('000'));
    });

    test('toPercentage debe retornar el valor con dos decimales y el símbolo %', () {
      const double value = 5.1234;
      final result = AppFormatters.toPercentage(value);
      
      expect(result, equals('5.12%'));
    });

    test('toPercentage debe redondear correctamente', () {
      const double value = 4.599;
      final result = AppFormatters.toPercentage(value);
      
      expect(result, equals('4.60%'));
    });

    test('formatDate debe retornar la fecha en formato dd MMM yyyy', () {
      final date = DateTime(2026, 3, 24); // 24 de Marzo de 2026
      final result = AppFormatters.formatDate(date);
      
      // Verificamos que contenga el día, el mes (abreviado) y el año
      expect(result.toLowerCase(), contains('24'));
      expect(result.toLowerCase(), contains('mar'));
      expect(result, contains('2026'));
    });
  });
}