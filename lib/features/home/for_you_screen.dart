import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class ForYouScreen extends ConsumerWidget {
  const ForYouScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _greetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(homeProfileProvider);
    final firstName = user.name.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('For You'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: () => context.push('/home-profile'),
            tooltip: 'Personalize',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
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
                Text(
                  '${_greeting()}, $firstName! ${_greetingEmoji()}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your ${profile.homeType} home profile',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Personalized recommendations
          const Text(
            'Recommended for you',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          if (profile.hasPets)
            _RecommendCard(
              emoji: '🐾',
              title: 'Pet-Safe Cleaning',
              subtitle: 'Eco-friendly products safe for your pets',
              onTap: () => context.push('/book/cleaning_basic'),
            ),

          if (profile.hasGarden)
            _RecommendCard(
              emoji: '🌱',
              title: 'Garden Care',
              subtitle: 'Keep your garden lush and healthy',
              onTap: () => context.push('/book/garden_maintenance'),
            ),

          _RecommendCard(
            emoji: '🧹',
            title: 'Rebook Home Cleaning',
            subtitle: 'Your last booked service — quick rebook',
            onTap: () => context.push('/quick-rebook'),
          ),

          const SizedBox(height: 20),

          // Preferred time slots
          const Text(
            'Your usual time',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: profile.preferredTimeSlots.map((slot) {
              final emoji = slot == 'morning'
                  ? '🌅'
                  : slot == 'afternoon'
                      ? '☀️'
                      : '🌙';
              return Chip(
                label: Text('$emoji ${slot[0].toUpperCase()}${slot.substring(1)}'),
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                labelStyle: const TextStyle(color: AppColors.primary, fontSize: 13),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Trending nearby
          const Text(
            'Trending in Koramangala',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...[
            ('🧹', 'Home Cleaning', '4.9 ⭐', 'cleaning_basic'),
            ('🗑️', 'Garbage Pickup', '4.8 ⭐', 'garbage_daily'),
            ('♻️', 'Paper Recycling', '4.7 ⭐', 'recycling_paper'),
          ].map(
            (item) => _TrendingCard(
              emoji: item.$1,
              title: item.$2,
              rating: item.$3,
              serviceId: item.$4,
            ),
          ),

          const SizedBox(height: 20),

          // You might also like
          const Text(
            'You might also like',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ('🧴', 'Deep Clean', '₹799', 'deep_full'),
                ('💻', 'E-Waste', '₹49', 'recycling_ewaste'),
                ('🌱', 'Garden', '₹349', 'garden_maintenance'),
                ('🏠', 'HomeGuard', '₹599', 'homeguard_basic'),
              ]
                  .map(
                    (item) => GestureDetector(
                      onTap: () => context.push('/book/${item.$4}'),
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.$1,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 4),
                            Text(item.$2,
                                style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center),
                            Text(item.$3,
                                style: const TextStyle(
                                    color: AppColors.primary, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RecommendCard extends StatelessWidget {
  const _RecommendCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji, title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x333C4A3C)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Book Now',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({
    required this.emoji,
    required this.title,
    required this.rating,
    required this.serviceId,
  });

  final String emoji, title, rating, serviceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x333C4A3C)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          Text(rating,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 12)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => context.push('/book/$serviceId'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Book',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
