import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/coin_model.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../data/repository/coin_repository.dart';
import '../../../data/services/local_storage.dart';
import '../../portfolio/controllers/portfolio_controller.dart';

class AddAssetController extends GetxController {
  final repository = CoinRepository();
  final allCoins = <CoinModel>[].obs;
  final filteredCoins = <CoinModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCoins();
  }

  Future<void> loadCoins() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await CoinRepository().fetchAllCoins();
      allCoins.assignAll(result);
      filteredCoins.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void searchCoins(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCoins.assignAll(allCoins);
      return;
    }
    final q = query.toLowerCase();
    filteredCoins.assignAll(
      allCoins
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.symbol.toLowerCase().contains(q) ||
                c.id.toLowerCase().contains(q),
          )
          .toList(),
    );
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    filteredCoins.assignAll(allCoins);
  }

  Future<void> addCoinToPortfolio(CoinModel coin, double quantity) async {
    try {
      isSubmitting.value = true;
      await LocalStorage.instance.init();
      final prefs = LocalStorage.instance;
      final data = prefs.getPortfolio();
      final list = data != null
          ? (jsonDecode(data) as List)
                .map((e) => PortfolioModel.fromJson(e))
                .toList()
          : <PortfolioModel>[];
      /// To show icon based on assets uncomment following line and use coin icon in object
      /// i have commented this because of api call limitations.

      // final coinIcon = await repository.fetchCoinIcon(coin.id);

      final index = list.indexWhere((e) => e.id == coin.id);
      if (index >= 0) {
        list[index] = PortfolioModel(
          id: coin.id,
          name: coin.name,
          symbol: coin.symbol,
          quantity: list[index].quantity + quantity,
          price: 0.0,
          // icon: coinIcon,
          icon: ''
        );
      } else {
        list.add(
          PortfolioModel(
            id: coin.id,
            name: coin.name,
            symbol: coin.symbol,
            quantity: quantity,
            price: 0.0,
            // icon: coinIcon,
            icon: ''
          ),
        );
      }

      await prefs.savePortfolio(
        jsonEncode(
          list.map((e) {
            return e.toJson();
          }).toList(),
        ),
      );

      Get.find<PortfolioController>().loadPortfolio();
      Get.back();

      Get.snackbar(
        'Success',
        '${coin.name} added to your portfolio',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green.withOpacity(0.8),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to add asset to portfolio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
