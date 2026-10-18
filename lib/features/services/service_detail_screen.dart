import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/providers/personalization_providers.dart';
import 'package:ecomins/providers/service_providers.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  const ServiceDetailScreen({
    super.key,
    required this.categoryId,
    required this.serviceId,
  });

  final String categoryId;
  final String serviceId;

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  String? _selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(serviceByIdProvider(widget.serviceId));
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.serviceId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          service?.name ?? 'Service',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : AppColors.onSurface,
            ),
            onPressed: () {
              final current = ref.read(favoritesProvider);
              final updated = Set<String>.from(current);
              if (isFav) {
                updated.remove(widget.serviceId);
              } else {
                updated.add(widget.serviceId);
              }
              ref.read(favoritesProvider.notifier).state = updated;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFav
                      ? 'Removed from favourites'
                      : 'Added to favourites ❤️'),
                ),
              );
            },
          ),
        ],
      ),
      body: service == null
          ? const Center(
              child: Text(
                'Service not found',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            )
          : _ServiceDetailBody(
              service: service,
              selectedPackageId: _selectedPackageId,
              onPackageSelected: (id) => setState(() => _selectedPackageId = id),
              onBook: () => context.push('/book/${widget.serviceId}'),
            ),
    );
  }
}

class _ServiceDetailBody extends StatelessWidget {
  const _ServiceDetailBody({
    required this.service,
    required this.selectedPackageId,
    required this.onPackageSelected,
    required this.onBook,
  });

  final ServiceModel service;
  final String? selectedPackageId;
  final ValueChanged<String> onPackageSelected;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section
              _HeroSection(service: service),
              const SizedBox(height: 20),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  service.description,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Packages section
              if (service.packages.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Choose a Package',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: service.packages.length,
                    itemBuilder: (context, index) {
                      final pkg = service.packages[index];
                      final isActive = selectedPackageId == pkg.id;
                      return _PackageCard(
                        package: pkg,
                        isActive: isActive,
                        onTap: () => onPackageSelected(pkg.id),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Promo code section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => context.push('/promo-codes'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Text('🎟️', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('Apply Promo Code',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.chevron_right,
                            color: AppColors.primary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),

        // Sticky bottom button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(color: Color(0x333C4A3C)),
              ),
            ),
            child: ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Book This Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x333C4A3C)),
      ),
      child: Column(
        children: [
          Text(service.iconAsset, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(
            service.name,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹${service.basePrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' / ${service.unit}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
              const SizedBox(width: 4),
              Text(
                service.avgRating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' (${service.totalBookings} bookings)',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              if (service.isEcoFriendly) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0x1A3FE56C),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x663FE56C)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🌿', style: TextStyle(fontSize: 11)),
                      SizedBox(width: 3),
                      Text(
                        'Eco Friendly',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.isActive,
    required this.onTap,
  });

  final ServicePackage package;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0x1A3FE56C)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0x333C4A3C),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              package.name,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '₹${package.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
