import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/data/models/service_model.dart';
import 'package:ecomins/providers/personalization_providers.dart';
import 'package:ecomins/shared/widgets/status_chip.dart';

/// Reusable service card used across the app.
class ServiceCardWidget extends ConsumerWidget {
  const ServiceCardWidget({
    super.key,
    required this.service,
    this.showFavorite = true,
    this.compact = false,
    this.onTap,
  });

  final ServiceModel service;
  final bool showFavorite;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(service.id);

    if (compact) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(service.iconAsset,
                      style: const TextStyle(fontSize: 22)),
                  const Spacer(),
                  if (service.isEcoFriendly)
                    const Text('🌿', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Text(service.name,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                AppUtils.formatCurrency(service.basePrice),
                style: AppTextStyles.price.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(service.iconAsset,
                  style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(service.name,
                            style: AppTextStyles.h4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (service.isEcoFriendly)
                        const StatusChip(
                          label: 'Eco',
                          color: AppColors.primary,
                          emoji: '🌿',
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(service.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        AppUtils.formatCurrency(service.basePrice),
                        style: AppTextStyles.price.copyWith(fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 13),
                      const SizedBox(width: 2),
                      Text(service.avgRating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite heart
            if (showFavorite)
              GestureDetector(
                onTap: () {
                  final notifier = ref.read(favoritesProvider.notifier);
                  final current = Set<String>.from(ref.read(favoritesProvider));
                  if (isFavorite) {
                    current.remove(service.id);
                  } else {
                    current.add(service.id);
                  }
                  notifier.state = current;
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.outline,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
