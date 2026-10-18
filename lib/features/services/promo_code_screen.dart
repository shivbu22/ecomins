import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class PromoCodeScreen extends ConsumerStatefulWidget {
  const PromoCodeScreen({super.key});

  @override
  ConsumerState<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends ConsumerState<PromoCodeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyCode() {
    final code = _controller.text.trim().toUpperCase();
    final found = MockData.promoCodes
        .where((p) => p.code == code)
        .firstOrNull;
    if (found == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code'),
          backgroundColor: Color(0xFF93000A),
        ),
      );
    } else {
      ref.read(appliedPromoProvider.notifier).state = found;
      ref.read(promoCodeProvider.notifier).state = code;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '🎉 $code applied! ${found.discountPercent > 0 ? '${found.discountPercent.toStringAsFixed(0)}% off' : '₹${found.maxDiscount.toStringAsFixed(0)} off'}'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final applied = ref.watch(appliedPromoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Promo Codes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.onSurface),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    hintStyle:
                        const TextStyle(color: AppColors.outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _applyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Applied promo
          if (applied != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(applied.code,
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        Text(applied.description,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(appliedPromoProvider.notifier)
                          .state = null;
                      ref
                          .read(promoCodeProvider.notifier)
                          .state = null;
                    },
                    child: const Text('Remove',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text('Available Offers',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          ...MockData.promoCodes.map(
            (promo) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x333C4A3C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.4)),
                        ),
                        child: Text(promo.code,
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                      ),
                      const Spacer(),
                      Text(
                        promo.discountPercent > 0
                            ? '${promo.discountPercent.toStringAsFixed(0)}% off'
                            : '₹${promo.maxDiscount.toStringAsFixed(0)} off',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(promo.description,
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Expires: Dec 31, 2025',
                          style: TextStyle(
                              color: AppColors.outline, fontSize: 11)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: promo.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Code copied!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0x333C4A3C)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy,
                                  size: 13,
                                  color: AppColors.onSurfaceVariant),
                              SizedBox(width: 4),
                              Text('Copy Code',
                                  style: TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
