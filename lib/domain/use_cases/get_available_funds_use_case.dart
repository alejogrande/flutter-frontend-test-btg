import 'package:btg_funds_app/domain/entities/fund_entity.dart';
import 'package:btg_funds_app/domain/repositories/fund_repository.dart';

class GetAvailableFundsUseCase {
  final FundRepository repository;

  GetAvailableFundsUseCase({required this.repository});

  // El método 'call' permite ejecutar: _getAvailableFundsUseCase()
  Future<List<FundEntity>> call() async {
    return await repository.getAvailableFunds();
  }
}