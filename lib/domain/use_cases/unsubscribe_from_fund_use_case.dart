import 'package:btg_funds_app/domain/repositories/account_repository.dart';

class UnsubscribeFromFundUseCase {
  final AccountRepository repository;

  UnsubscribeFromFundUseCase({required this.repository});

  // domain/use_cases/unsubscribe_from_fund_use_case.dart

Future<String?> call({required String fundName, required double amount}) async {
  try {
    // Solo llamamos a unsubscribe. El repo se encarga de:
    // 1. Validar que exista.
    // 2. Reemplazar la 'subscription' por 'cancellation'.
    // 3. Sumar el balance.
    await repository.unsubscribe(fundName, amount);
    return null; 
  } catch (e) {
    return e.toString();
  }
}
}