import 'package:flutter_bloc/flutter_bloc.dart';
import 'funds_event.dart';
import 'funds_state.dart';
import '../../../../domain/use_cases/get_available_funds_use_case.dart';

class FundsBloc extends Bloc<FundsEvent, FundsState> {
  final GetAvailableFundsUseCase getAvailableFundsUseCase;

  FundsBloc({required this.getAvailableFundsUseCase}) : super(FundsInitial()) {
    on<FetchFundsEvent>((event, emit) async {
      emit(FundsLoading());
      try {
        final funds = await getAvailableFundsUseCase();
        emit(FundsLoaded(funds));
      } catch (e) {
        emit(FundsError("No se pudieron cargar los fondos. Inténtalo de nuevo."));
      }
    });
  }
}