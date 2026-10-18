import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/countdown_timer.dart';

const _offers = [
  (
    '☀️',
    'Summer Deep Clean',
    '35% off on full home deep clean',
    '₹799',
    '₹1,199',
    'deep_full',
  ),
  (
    '🌧️',
    'Monsoon Waterproofing',
    'Protect your home from leaks',
    '₹1,499',
    '₹1,999',
    'deep_full',
  ),
  (
    '🪔',
    'Festival Cleaning Package',
    'Get your home sparkling for the festival',
    '₹999',
    '₹1,499',
    'cleaning_basic',
  ),
  (
    '🎊',
    'New Year Bundle Deal',
    'Deep clean + garden + garbage for a month',
    '₹2,499',
    '₹3,499',
    'deep_full',
  ),
];

class SeasonalOffersScreen extends StatelessWidget {
  const SeasonalOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final endTime = DateTime.now().add(const Duration(hours: 23, minutes: 45));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Seasonal Offers 🌸'),
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
                const Text(
                  '☀️ Summer Special',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Beat the heat with deep cleaning',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Ends in: ',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 13),
                    ),
                    CountdownTimer(endTime: endTime),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._offers.map((o) => _OfferCard(
                emoji: o.$1,
                title: o.$2,
                subtitle: o.$3,
                price: o.$4,
                original: o.$5,
                serviceId: o.$6,
              )),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.original,
    required this.serviceId,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String price;
  final String original;
  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(price,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(width: 6),
                    Text(original,
                        style: const TextStyle(
                          color: AppColors.outline,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.outline,
                        )),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/book/$serviceId'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Grab Deal',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
