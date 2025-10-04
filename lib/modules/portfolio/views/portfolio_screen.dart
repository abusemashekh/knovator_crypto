import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/portfolio_header.dart';
import '../widgets/portfolio_card.dart';
import '../../assets/views/add_asset_screen.dart';

class PortfolioScreen extends StatelessWidget {
  final controller = Get.put(PortfolioController());

  PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildView(),
    );
  }

  Widget _buildView() {
    return SafeArea(
      child: Obx(
        () => controller.error.value.isNotEmpty
            ? _buildErrorState()
            : _buildSuccessState(),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        PortfolioHeader(
          totalValue: controller.totalValue,
          portfolioCount: controller.portfolios.length,
        ),
        if (controller.portfolios.isNotEmpty) _buildSortingOptions(),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () => controller.refreshPrices(),
            child: controller.isLoading.value && controller.portfolios.isEmpty
                ? _buildLoadingState()
                : controller.portfolios.isEmpty
                ? _buildEmptyState()
                : _buildDataState(),
          ),
        ),
      ],
    );
  }

  Widget _buildSortingOptions() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                Icons.sort_rounded,
                size: 20,
                color: AppColors.textDark.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 12),
              _buildSortChip(
                'Name (A-Z)',
                SortType.nameAsc,
                Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 8),
              _buildSortChip(
                'Name (Z-A)',
                SortType.nameDesc,
                Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 8),
              _buildSortChip(
                'Value (High)',
                SortType.valueDesc,
                Icons.trending_up_rounded,
              ),
              const SizedBox(width: 8),
              _buildSortChip(
                'Value (Low)',
                SortType.valueAsc,
                Icons.trending_down_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, SortType type, IconData icon) {
    final isSelected = controller.sortType.value == type;

    return GestureDetector(
      onTap: () => controller.setSortType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.accent.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.accent,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: controller.portfolios.length,
      itemBuilder: (context, index) => Dismissible(
        key: Key(controller.portfolios[index].id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (direction) {
          controller.removeAsset(index);
        },
        child: PortfolioCard(item: controller.portfolios[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: AppColors.textDark.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No assets added yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first crypto',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textDark.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.accent),
          const SizedBox(height: 16),
          Text(
            'Loading portfolio...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textDark.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.accent,
      onPressed: () => Get.to(
        () => AddAssetScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      ),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Asset',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textDark.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.error.value = '';
                controller.loadPortfolio();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
