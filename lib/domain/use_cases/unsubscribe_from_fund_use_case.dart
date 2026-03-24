import 'package:btg_funds_app/domain/repositories/account_repository.dart';

class UnsubscribeFromFundUseCase {
  final AccountRepository repository;

  UnsubscribeFromFundUseCase({required this.repository});

Future<String?> call({required String fundName, required double amount}) async {
  try {
    await repository.unsubscribe(fundName, amount);
    return null; 
  } catch (e) {
    return e.toString();
  }
}
}