import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/personalization_providers.dart';
import 'package:ecomins/providers/service_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final allServices = ref.watch(allServicesProvider);
    final favorites =
        allServices.where((s) => favoriteIds.contains(s.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Favourites ❤️'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('❤️',
                        style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    const Text(
                      'No favourites yet.',
                      style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap ❤️ on any service to save it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Explore Services'),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final service = favorites[index];
                return Container(
                  padding: const EdgeInsets.all(12),
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
                          Text(service.iconAsset,
                              style: const TextStyle(fontSize: 28)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              final current =
                                  ref.read(favoritesProvider);
                              ref
                                  .read(favoritesProvider.notifier)
                                  .state = Set.from(current)
                                ..remove(service.id);
                            },
                            child: const Icon(Icons.favorite,
                                color: Colors.red, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(service.name,
                          style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('₹${service.basePrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 12),
                          const SizedBox(width: 2),
                          Text(service.avgRating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 11)),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              context.push('/book/${service.id}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)),
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Book',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
