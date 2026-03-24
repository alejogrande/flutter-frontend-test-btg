import '../entities/fund_entity.dart';

abstract class FundRepository {
  Future<List<FundEntity>> getAvailableFunds();
}