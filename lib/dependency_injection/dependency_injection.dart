import 'package:btg_funds_app/presentation/navigation/navigation_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => NavigationCubit());
}