import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class ServiceBundleScreen extends StatelessWidget {
  const ServiceBundleScreen({super.key});

  static const _bundles = [
    _Bundle(
      emoji: '🏠',
      name: 'Home Care Bundle',
      services: ['Cleaning', 'Sweeper', 'Garbage'],
      originalPrice: 999,
      bundlePrice: 799,
      savings: 200,
      serviceId: 'cleaning_basic',
      description: 'Complete home care with cleaning, sweeping, and garbage collection.',
    ),
    _Bundle(
      emoji: '🌿',
      name: 'Eco Bundle',
      services: ['Recycling', 'Garden', 'Composting'],
      originalPrice: 749,
      bundlePrice: 599,
      savings: 150,
      serviceId: 'recycling_paper',
      description: 'Go green with recycling, garden maintenance, and composting services.',
    ),
    _Bundle(
      emoji: '💎',
      name: 'Premium Bundle',
      services: ['Deep Clean', 'HomeGuard', 'Garden'],
      originalPrice: 1899,
      bundlePrice: 1499,
      savings: 400,
      serviceId: 'deep_full',
      description: 'Premium home care with deep cleaning, security check, and garden maintenance.',
    ),
  ];

  void _showBundleDetails(BuildContext context, _Bundle bundle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(bundle.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(bundle.name, style: const TextStyle(color: AppColors.onSurface, fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            Text(bundle.description, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
            const SizedBox(height: 16),
            const Text('Included Services', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...bundle.services.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(s, style: const TextStyle(color: AppColors.onSurface, fontSize: 14)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('₹${bundle.originalPrice}', style: const TextStyle(color: AppColors.outline, fontSize: 16, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 10),
                Text('₹${bundle.bundlePrice}', style: const TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w800)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('Save ₹${bundle.savings}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/book/${bundle.serviceId}');
                },
                child: const Text('Confirm & Book', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Service Bundles'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Save more with combos',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ..._bundles.map((b) => _BundleCard(bundle: b, onTap: () => _showBundleDetails(context, b))),
        ],
      ),
    );
  }
}

class _BundleCard extends StatelessWidget {
  const _BundleCard({required this.bundle, required this.onTap});
  final _Bundle bundle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(bundle.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bundle.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(bundle.services.join(' + '), style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text('Save ₹${bundle.savings}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('₹${bundle.originalPrice}', style: const TextStyle(color: AppColors.outline, fontSize: 14, decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 8),
              Text('₹${bundle.bundlePrice}', style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800)),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onTap,
                child: const Text('Book Bundle', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bundle {
  const _Bundle({
    required this.emoji,
    required this.name,
    required this.services,
    required this.originalPrice,
    required this.bundlePrice,
    required this.savings,
    required this.serviceId,
    required this.description,
  });
  final String emoji;
  final String name;
  final List<String> services;
  final int originalPrice;
  final int bundlePrice;
  final int savings;
  final String serviceId;
  final String description;
}
