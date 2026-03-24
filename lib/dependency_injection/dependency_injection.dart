import 'package:btg_funds_app/data/datasources/fund_remote_datasource.dart';
import 'package:btg_funds_app/data/repositories/account_repository_impl.dart';
import 'package:btg_funds_app/data/repositories/fund_repository_impl.dart';
import 'package:btg_funds_app/domain/repositories/account_repository.dart';
import 'package:btg_funds_app/domain/repositories/fund_repository.dart';
import 'package:btg_funds_app/domain/use_cases/get_available_funds_use_case.dart';
import 'package:btg_funds_app/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:btg_funds_app/domain/use_cases/unsubscribe_from_fund_use_case.dart'; // <--- IMPORTADO
import 'package:btg_funds_app/presentation/blocs/account/account_bloc.dart';
import 'package:btg_funds_app/presentation/features/funds_explorer/bloc/funds_bloc.dart';
import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- BLOCS ---
  // Usamos factory para que se cree una instancia nueva cada vez que se necesite el Bloc
  sl.registerFactory(() => FundsBloc(getAvailableFundsUseCase: sl()));
  
  sl.registerFactory(
    () => AccountBloc(
      repository: sl(), 
      subscribeToFundUseCase: sl(),
      unsubscribeFromFundUseCase: sl(), // <--- Ahora sí encontrará el registro de abajo
    ),
  );

  // --- USE CASES ---
  sl.registerLazySingleton(() => GetAvailableFundsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SubscribeToFundUseCase(repository: sl()));
  sl.registerLazySingleton(() => UnsubscribeFromFundUseCase(repository: sl())); // <--- REGISTRADO

  // --- REPOSITORIES ---
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(remoteDataSource: sl()),
  );

  // --- DATA SOURCES ---
  sl.registerLazySingleton<FundRemoteDataSource>(
    () => FundMockDataSourceImpl(),
  );

  // --- NAVIGATION & OTROS ---
  sl.registerLazySingleton(() => NavigationCubit());
}