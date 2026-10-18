import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

class ServicePackageDetailScreen extends StatelessWidget {
  const ServicePackageDetailScreen({super.key, required this.packageId});

  final String packageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Package Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🧴', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                const Text(
                  'Premium Deep Clean Package',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '₹1,199',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Save 20%',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '⏱ Duration: 4 hours',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: "What's Included"),
          const SizedBox(height: 12),
          ..._included.map((item) => _CheckItem(text: item, included: true)),
          const SizedBox(height: 20),
          const _SectionTitle(title: "What's Not Included"),
          const SizedBox(height: 12),
          ..._excluded.map((item) => _CheckItem(text: item, included: false)),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Book This Package',
            icon: Icons.calendar_today_outlined,
            onTap: () => context.push('/book/deep_full'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

const _included = [
  'All rooms dusting & mopping',
  'Kitchen deep scrub (appliances included)',
  'Bathroom & toilet sanitization',
  'Window cleaning (interior)',
  'Eco-certified cleaning products',
  'Waste segregation & disposal',
];

const _excluded = [
  'Exterior window cleaning',
  'Pest control treatment',
  'Furniture polishing',
  'Carpet shampooing',
];

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({required this.text, required this.included});
  final String text;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle : Icons.cancel_outlined,
            color: included ? AppColors.primary : AppColors.outline,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: included
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
