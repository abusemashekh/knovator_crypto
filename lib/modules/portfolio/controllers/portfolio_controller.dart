import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../data/repository/coin_repository.dart';
import '../../../data/services/local_storage.dart';

class PortfolioController extends GetxController {
  final repository = CoinRepository();
  final portfolios = <PortfolioModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final sortType = SortType.none.obs;
  final priceChanges = <String, PriceChange>{}.obs;

  Timer? _periodicTimer;
  final _autoRefreshDuration = const Duration(minutes: 5);

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();
    _startPeriodicPriceUpdate();
  }

  @override
  void onClose() {
    _periodicTimer?.cancel();
    super.onClose();
  }

  void _startPeriodicPriceUpdate() {
    _periodicTimer = Timer.periodic(_autoRefreshDuration, (timer) {
      if (portfolios.isNotEmpty) {
        refreshPrices(showLoading: false);
      }
    });
  }

  Future<void> loadPortfolio() async {
    try {
      error.value = '';
      await LocalStorage.instance.init();
      final data = LocalStorage.instance.getPortfolio();
      if (data != null) {
        final list = jsonDecode(data) as List;
        portfolios.assignAll(
          list.map((e) {
            log(e.toString());
            return PortfolioModel.fromJson(e);
          }).toList(),
        );
      }
      await refreshPrices();
    } catch (e) {
      error.value = 'Failed to load portfolio';
    }
  }

  Future<void> refreshPrices({bool showLoading = true}) async {
    try {
      if (portfolios.isEmpty) {
        isLoading.value = false;
        return;
      }
      if (showLoading) {
        isLoading.value = true;
      }
      error.value = '';

      final oldPrices = <String, double>{};
      for (var item in portfolios) {
        oldPrices[item.id] = item.price;
      }

      final updated = await repository.updatePrices(portfolios);

      for (var item in updated) {
        final oldPrice = oldPrices[item.id] ?? 0;
        final newPrice = item.price;
        if (oldPrice > 0 && oldPrice != newPrice) {
          priceChanges[item.id] = PriceChange(
            isIncrease: newPrice > oldPrice,
            timestamp: DateTime.now(),
          );

          Future.delayed(const Duration(seconds: 3), () {
            priceChanges.remove(item.id);
          });
        }
      }

      portfolios.assignAll(updated);
      _applySorting();
      await _savePortfolio();
    } catch (e) {
      error.value = e.toString();
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  void setSortType(SortType type) {
    if (sortType.value == type) {
      sortType.value = SortType.none;
    } else {
      sortType.value = type;
    }
    _applySorting();
  }

  void _applySorting() {
    final list = List<PortfolioModel>.from(portfolios);

    switch (sortType.value) {
      case SortType.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.nameDesc:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortType.valueAsc:
        list.sort((a, b) => a.totalValue.compareTo(b.totalValue));
        break;
      case SortType.valueDesc:
        list.sort((a, b) => b.totalValue.compareTo(a.totalValue));
        break;
      case SortType.none:
        break;
    }

    portfolios.assignAll(list);
  }

  Future<void> removeAsset(int index) async {
    try {
      final removedId = portfolios[index].id;
      portfolios.removeAt(index);
      priceChanges.remove(removedId);
      await _savePortfolio();
      Get.snackbar(
        'Success',
        'Asset removed from portfolio',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green.withOpacity(0.8),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = 'Failed to remove asset';
    }
  }

  Future<void> _savePortfolio() async {
    await LocalStorage.instance.savePortfolio(
      jsonEncode(portfolios.map((e) => e.toJson()).toList()),
    );
  }

  double get totalValue =>
      portfolios.fold(0, (sum, item) => sum + item.totalValue);

  PriceChange? getPriceChange(String coinId) {
    return priceChanges[coinId];
  }
}

enum SortType { none, nameAsc, nameDesc, valueAsc, valueDesc }

class PriceChange {
  final bool isIncrease;
  final DateTime timestamp;

  PriceChange({required this.isIncrease, required this.timestamp});
}
