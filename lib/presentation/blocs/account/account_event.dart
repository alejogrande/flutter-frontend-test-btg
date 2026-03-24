abstract class AccountEvent {}

class LoadAccountInfoEvent extends AccountEvent {}

class SubscribeToFundEvent extends AccountEvent {
  final String fundName;
  final double amount;
  final double minAmount;
  SubscribeToFundEvent({
    required this.fundName,
    required this.amount,
    required this.minAmount,
  });
}
