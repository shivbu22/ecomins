import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';

/// Provider to track if the promo banner has been dismissed.
final _promoDismissedProvider = StateProvider<bool>((ref) => false);

/// Dismissible promo banner shown on home screen.
class PromoBannerWidget extends ConsumerWidget {
  const PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDismissed = ref.watch(_promoDismissedProvider);
    if (isDismissed) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () => context.push('/promo-codes'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A4A2A), Color(0xFF0D3A20)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Use ECO20 for 20% off your next booking!',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(_promoDismissedProvider.notifier).state = true,
                child: const Icon(Icons.close,
                    color: AppColors.onSurfaceVariant, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
