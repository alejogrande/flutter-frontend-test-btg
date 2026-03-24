abstract class AccountEvent {}

class LoadAccountInfoEvent extends AccountEvent {}

class SubscribeToFundEvent extends AccountEvent {
  final String fundName;
  final double amount;
  final double minAmount;
  final double annualRate;
  SubscribeToFundEvent({
    required this.fundName,
    required this.amount,
    required this.minAmount,
    required this.annualRate,
  });
}
// presentation/blocs/account/account_event.dart
class UnsubscribeFromFundEvent extends AccountEvent {
  final String fundName;
  final double amount;

  UnsubscribeFromFundEvent({required this.fundName, required this.amount});

  List<Object> get props => [fundName, amount];
}
