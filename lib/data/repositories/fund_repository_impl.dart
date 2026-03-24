import 'package:btg_funds_app/data/datasources/fund_remote_datasource.dart';

import '../../domain/entities/fund_entity.dart';
import '../../domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  final FundRemoteDataSource remoteDataSource;

  FundRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FundEntity>> getAvailableFunds() {
    return remoteDataSource.getAvailableFunds();
  }
}
