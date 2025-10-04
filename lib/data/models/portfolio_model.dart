class PortfolioModel {
  final String id;
  final String name;
  final String symbol;
  final double quantity;
  final double price;
  final String? icon;

  PortfolioModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.price,
    this.icon,
  });

  double get totalValue => quantity * price;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
      'icon': icon,
    };
  }
}