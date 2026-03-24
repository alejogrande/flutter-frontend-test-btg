import 'package:btg_funds_app/domain/entities/fund_entity.dart';



abstract class FundsState {}



class FundsInitial extends FundsState {}



class FundsLoading extends FundsState {}



class FundsLoaded extends FundsState {

  final List<FundEntity> funds;

  FundsLoaded(this.funds);

}



class FundsError extends FundsState {

  final String message;

  FundsError(this.message);

}