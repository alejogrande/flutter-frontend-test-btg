import 'package:btg_funds_app/domain/entities/fund_entity.dart';

class FundModel extends FundEntity {
  FundModel({
    required super.id,
    required super.name,
    required super.minimumAmount,
    required super.category,
    required super.annualRate,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'],
      name: json['name'],
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      category: json['category'],
      annualRate:(json['annualRate'] as num).toDouble(),
    );
  }
}