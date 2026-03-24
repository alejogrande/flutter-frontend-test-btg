import 'package:bloc_test/bloc_test.dart';
import 'package:btg_funds_app/domain/use_cases/get_available_funds_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_bloc.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_event.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_state.dart';
import 'package:btg_funds_app/domain/entities/fund_entity.dart';

// 1. Mock del caso de uso
class MockGetAvailableFundsUseCase extends Mock implements GetAvailableFundsUseCase {}

void main() {
  late FundsBloc fundsBloc;
  late MockGetAvailableFundsUseCase mockUseCase;

  // Datos de prueba
  final tFundsList = [
    FundEntity(id: '1', name: 'Fondo 1', minimumAmount: 50000, category: 'FIC', annualRate: 0.05),
  ];

  setUp(() {
    mockUseCase = MockGetAvailableFundsUseCase();
    fundsBloc = FundsBloc(getAvailableFundsUseCase: mockUseCase);
  });

  // Es buena práctica cerrar el bloc después de cada test
  tearDown(() {
    fundsBloc.close();
  });

  group('FundsBloc Tests', () {
    test('El estado inicial debe ser FundsInitial', () {
      expect(fundsBloc.state, isA<FundsInitial>());
    });

    blocTest<FundsBloc, FundsState>(
      'Debe emitir [FundsLoading, FundsLoaded] cuando la carga es exitosa',
      build: () {
        // Arrange: Preparamos el mock para devolver la lista
        when(() => mockUseCase.call()).thenAnswer((_) async => tFundsList);
        return fundsBloc;
      },
      act: (bloc) => bloc.add(FetchFundsEvent()),
      expect: () => [
        isA<FundsLoading>(),
        isA<FundsLoaded>().having((state) => state.funds, 'funds', tFundsList),
      ],
      verify: (_) {
        verify(() => mockUseCase.call()).called(1);
      },
    );

    blocTest<FundsBloc, FundsState>(
      'Debe emitir [FundsLoading, FundsError] cuando el caso de uso falla',
      build: () {
        // Arrange: Forzamos un error
        when(() => mockUseCase.call()).thenThrow(Exception('Error de red'));
        return fundsBloc;
      },
      act: (bloc) => bloc.add(FetchFundsEvent()),
      expect: () => [
        isA<FundsLoading>(),
        isA<FundsError>().having(
          (state) => state.message, 
          'message', 
          "No se pudieron cargar los fondos. Inténtalo de nuevo."
        ),
      ],
    );
  });
}