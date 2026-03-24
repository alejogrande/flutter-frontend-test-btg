import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/entities/transaction_type_entity.dart';

// Creamos el Mock del repositorio
class MockAccountRepository extends Mock implements AccountRepository {}

// Necesario para que mocktail entienda la entidad TransactionEntity en los "verify"
class FakeTransactionEntity extends Fake implements TransactionEntity {}

void main() {
  late SubscribeToFundUseCase useCase;
  late MockAccountRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransactionEntity());
  });

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = SubscribeToFundUseCase(repository: mockRepository);
  });

  group('SubscribeToFundUseCase Tests', () {
    const tFundName = 'FONDO_TEST';
    const tMinAmount = 50000.0;
    const tAnnualRate = 0.05;

    test('Debe retornar error si el monto es menor al mínimo requerido', () async {
      // Arrange: El balance no importa aquí porque la primera regla es el mínimo
      when(() => mockRepository.getBalance()).thenReturn(100000.0);

      // Act
      final result = await useCase.call(
        fundName: tFundName,
        amount: 10000.0, // Menor a 50.000
        minAmount: tMinAmount,
        annualRate: tAnnualRate,
      );

      // Assert
      expect(result, contains('el monto mínimo es \$50000.0'));
      verifyNever(() => mockRepository.updateBalance(any()));
    });

    test('Debe retornar error si el usuario no tiene saldo suficiente', () async {
      // Arrange: Saldo de 30k para una inversión de 60k
      when(() => mockRepository.getBalance()).thenReturn(30000.0);

      // Act
      final result = await useCase.call(
        fundName: tFundName,
        amount: 60000.0, 
        minAmount: tMinAmount,
        annualRate: tAnnualRate,
      );

      // Assert
      expect(result, contains('No tiene saldo disponible'));
      verifyNever(() => mockRepository.updateBalance(any()));
    });

    test('Debe actualizar balance y guardar transacción cuando los datos son válidos', () async {
      // Arrange
      when(() => mockRepository.getBalance()).thenReturn(100000.0);
      when(() => mockRepository.updateBalance(any())).thenAnswer((_) async => {});
      when(() => mockRepository.saveTransaction(any())).thenAnswer((_) async => {});

      // Act
      final result = await useCase.call(
        fundName: tFundName,
        amount: 70000.0, 
        minAmount: tMinAmount,
        annualRate: tAnnualRate,
      );

      // Assert
      expect(result, isNull); // Éxito retorna null
      verify(() => mockRepository.updateBalance(30000.0)).called(1); // 100k - 70k
      verify(() => mockRepository.saveTransaction(any())).called(1);
    });
  });
}