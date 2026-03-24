import 'package:btg_funds_app/domain/use_cases/unsubscribe_from_fund_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';

// Reutilizamos el Mock del repositorio
class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late UnsubscribeFromFundUseCase useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = UnsubscribeFromFundUseCase(repository: mockRepository);
  });

  group('UnsubscribeFromFundUseCase Tests', () {
    const tFundName = 'DEUDAPRIVADA';
    const tAmount = 50000.0;

    test('Debe retornar null cuando la desvinculación es exitosa', () async {
      // Arrange: Simulamos que el repositorio completa la tarea sin errores
      when(() => mockRepository.unsubscribe(any(), any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await useCase.call(fundName: tFundName, amount: tAmount);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.unsubscribe(tFundName, tAmount)).called(1);
    });

    test('Debe retornar el mensaje de error cuando el repositorio lanza una excepción', () async {
      // Arrange: Forzamos al repositorio a lanzar una excepción
      const errorMessage = "Inversión no encontrada";
      when(() => mockRepository.unsubscribe(any(), any()))
          .thenThrow(Exception(errorMessage));

      // Act
      final result = await useCase.call(fundName: tFundName, amount: tAmount);

      // Assert
      // Verificamos que el resultado contenga el texto del error
      expect(result, contains(errorMessage));
      verify(() => mockRepository.unsubscribe(tFundName, tAmount)).called(1);
    });
  });
}