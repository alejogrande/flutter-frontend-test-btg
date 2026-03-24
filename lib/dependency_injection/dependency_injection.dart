import 'package:btg_funds_app/data/datasources/fund_remote_datasource.dart';
import 'package:btg_funds_app/data/repositories/account_repository_impl.dart';
import 'package:btg_funds_app/data/repositories/fund_repository_impl.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/repositories/fund_repository.dart';
import 'package:btg_funds_app/domain/use_cases/get_available_funds_use_case.dart';
import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_bloc.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  //Blocs
  sl.registerFactory(() => FundsBloc(getAvailableFundsUseCase: sl()));
  sl.registerFactory(
    () => AccountBloc(
      repository: sl(), // Busca el AccountRepository registrado
      subscribeToFundUseCase:
          sl(), // Busca el SubscribeToFundUseCase registrado
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAvailableFundsUseCase(repository: sl()));
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  sl.registerLazySingleton(() => SubscribeToFundUseCase(repository: sl()));

  // DataSources
  sl.registerLazySingleton<FundRemoteDataSource>(
    () => FundMockDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(remoteDataSource: sl()),
  );

  // Navigation
  sl.registerLazySingleton(() => NavigationCubit());
}
