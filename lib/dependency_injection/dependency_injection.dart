import 'package:btg_funds_app/data/datasources/fund_remote_datasource.dart';
import 'package:btg_funds_app/data/repositories/fund_repository_impl.dart';
import 'package:btg_funds_app/domain/repositories/fund_repository.dart';
import 'package:btg_funds_app/domain/use_cases/get_available_funds_use_case.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_bloc.dart';
import 'package:btg_funds_app/presentation/navigation/navigation_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {

  //Blocs
  sl.registerFactory(() => FundsBloc(getAvailableFundsUseCase: sl())); 

  // Use Cases
  sl.registerLazySingleton(() => GetAvailableFundsUseCase(repository: sl()));
  
  // DataSources
  sl.registerLazySingleton<FundRemoteDataSource>(() => FundMockDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(remoteDataSource: sl()),
  );

  // Navigation 
  sl.registerLazySingleton(() => NavigationCubit());
}