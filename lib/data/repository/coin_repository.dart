import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';
import '../models/portfolio_model.dart';

class CoinRepository {
  final baseUrl = 'https://api.coingecko.com/api/v3';
  static const _rateLimitMessage =
      'Too many requests! Please wait a moment and try again.';

  Future<List<CoinModel>> fetchAllCoins() async {
    final response = await http.get(Uri.parse('$baseUrl/coins/list'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => CoinModel.fromJson(e)).toList();
    } else if (response.statusCode == 429) {
      throw Exception(_rateLimitMessage);
    } else {
      throw Exception('Failed to fetch coins (status: ${response.statusCode})');
    }
  }

  Future<String?> fetchCoinIcon(String coinId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/coins/$coinId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['image']?['small'] ?? data['image']?['thumb'];
      } else if (response.statusCode == 429) {
        throw Exception(_rateLimitMessage);
      }
    } catch (e) {
      log('fetchCoinIcon error: $e');
      rethrow;
    }
    return null;
  }

  Future<Map<String, double>> fetchPrices(List<String> ids) async {
    final response = await http.get(
      Uri.parse('$baseUrl/simple/price?ids=${ids.join(',')}&vs_currencies=usd'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, (v['usd'] as num).toDouble()));
    } else if (response.statusCode == 429) {
      throw Exception(_rateLimitMessage);
    } else {
      throw Exception('Failed to fetch prices (status: ${response.statusCode})');
    }
  }

  Future<List<PortfolioModel>> updatePrices(List<PortfolioModel> current) async {
    if (current.isEmpty) return current;
    try {
      final ids = current.map((e) => e.id).toList();
      final prices = await fetchPrices(ids);
      return current.map((e) {
        return PortfolioModel(
          id: e.id,
          name: e.name,
          symbol: e.symbol,
          quantity: e.quantity,
          price: prices[e.id] ?? e.price,
          icon: e.icon,
        );
      }).toList();
    } catch (e) {
      log('updatePrices error: $e');
      rethrow;
    }
  }
}
