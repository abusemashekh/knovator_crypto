class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String? icon;

  CoinModel({required this.id, required this.symbol, required this.name, this.icon});

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
