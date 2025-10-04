import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../data/models/coin_model.dart';
import '../controllers/add_asset_controller.dart';

class QuantityInputDialog extends StatelessWidget {
  final CoinModel coin;

  QuantityInputDialog({super.key, required this.coin});

  final TextEditingController controller = TextEditingController();
  final List<int> quickAmounts = [10, 50, 100, 1000, 10000, 25000, 50000];
  final RxString errorText = ''.obs;
  final RxString selectedAmount = ''.obs;

  void _validateAndSubmit() {
    final qty = double.tryParse(controller.text);
    if (qty == null || qty <= 0) {
      errorText.value = 'Please enter a valid quantity';
      return;
    }
    errorText.value = '';
    final assetController = Get.find<AddAssetController>();
    assetController.addCoinToPortfolio(coin, qty);
  }

  @override
  Widget build(BuildContext context) {
    final assetController = Get.find<AddAssetController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add ${coin.name}',
              style: AppTextStyles.heading.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              coin.symbol.toUpperCase(),
              style: AppTextStyles.subheading.copyWith(
                fontSize: 13,
                color: AppColors.textDark.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
                  () => TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter amount',
                  errorText: errorText.value.isEmpty ? null : errorText.value,
                  prefixIcon: Icon(Icons.numbers, color: AppColors.accent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accent, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.accent.withOpacity(0.05),
                ),
                onChanged: (value) {
                  if (errorText.value.isNotEmpty) {
                    errorText.value = '';
                  }
                  selectedAmount.value = value;
                },
                onSubmitted: (_) => _validateAndSubmit(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
                  () => Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: quickAmounts.map((amount) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.text = amount.toString();
                        selectedAmount.value = amount.toString();
                        errorText.value = '';
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedAmount.value == amount.toString()
                                ? AppColors.accent
                                : AppColors.textDark.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: selectedAmount.value == amount.toString()
                              ? AppColors.accent.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Text(
                          amount.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedAmount.value == amount.toString()
                                ? AppColors.accent
                                : AppColors.textDark.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                        () => ElevatedButton(
                      onPressed: assetController.isSubmitting.value
                          ? null
                          : _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: assetController.isSubmitting.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : Text(
                        'Add',
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}