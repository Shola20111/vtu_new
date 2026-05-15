class DataPlan {
  final String code;
  final String name;
  final String validity;
  final double price;

  DataPlan({
    required this.code,
    required this.name,
    required this.validity,
    required this.price,
  });

  String get formattedPrice => 'N${price.toInt()}';

  factory DataPlan.fromJson(Map<String, dynamic> json) {
    return DataPlan(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      validity: json['validity']?.toString() ?? '30 days',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class DataPlanResponse {
  final bool success;
  final String network;
  final List<DataPlan> plans;

  DataPlanResponse({
    required this.success,
    required this.network,
    required this.plans,
  });

  factory DataPlanResponse.fromJson(Map<String, dynamic> json) {
    return DataPlanResponse(
      success: json['success'] ?? false,
      network: json['network']?.toString() ?? '',
      plans: (json['plans'] as List?)?.map((p) => DataPlan.fromJson(p)).toList() ?? [],
    );
  }
}
