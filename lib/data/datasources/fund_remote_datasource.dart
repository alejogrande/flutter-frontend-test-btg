import '../models/fund_model.dart';

abstract class FundRemoteDataSource {
  Future<List<FundModel>> getAvailableFunds();
}

class FundMockDataSourceImpl implements FundRemoteDataSource {
  @override
  Future<List<FundModel>> getAvailableFunds() async {
    // Simulacion de latencia de red de 1 segundo
    await Future.delayed(const Duration(seconds: 1));

    final mockData = [
      {'id': '1', 'name': 'FPV_BTG_PACTUAL_RECAUDADORA', 'minimumAmount': 75000, 'category': 'FPV','annualRate':0.0460},
      {'id': '2', 'name': 'FPV_BTG_PACTUAL_ECOPETROL', 'minimumAmount': 125000, 'category': 'FPV','annualRate':0.0510},
      {'id': '3', 'name': 'DEUDAPRIVADA', 'minimumAmount': 50000, 'category': 'FIC','annualRate':0.0415},
      {'id': '4', 'name': 'FDO-ACCIONES', 'minimumAmount': 250000, 'category': 'FIC','annualRate':0.0595},
      {'id': '5', 'name': 'FPV_BTG_PACTUAL_DINAMICA', 'minimumAmount': 100000, 'category': 'FPV','annualRate':0.0485},
    ];

    return mockData.map((json) => FundModel.fromJson(json)).toList();
  }
}