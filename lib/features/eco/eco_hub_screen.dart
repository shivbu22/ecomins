import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';

class EcoHubScreen extends ConsumerWidget {
  const EcoHubScreen({super.key});

  static const _actions = [
    _EcoAction(emoji: '🌱', label: 'Sustainability\nImpact', route: '/eco/impact'),
    _EcoAction(emoji: '🏆', label: 'Leaderboard', route: '/eco/leaderboard'),
    _EcoAction(emoji: '🎁', label: 'Rewards', route: '/eco/rewards'),
    _EcoAction(emoji: '🌍', label: 'Carbon\nCredits', route: '/eco/carbon'),
    _EcoAction(emoji: '📅', label: 'Events', route: '/eco/events'),
    _EcoAction(emoji: '🏠', label: 'Smart Home', route: '/eco/smarthome'),
    _EcoAction(emoji: '🧮', label: 'Calculator', route: '/eco/calculator'),
    _EcoAction(emoji: '🏅', label: 'Badges', route: '/eco/badges'),
    _EcoAction(emoji: '🎯', label: 'Challenges', route: '/eco/challenges'),
    _EcoAction(emoji: '🌍', label: 'Offset', route: '/eco/offset'),
    _EcoAction(emoji: '📰', label: 'Eco News', route: '/eco/news'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final eco = user.ecoProfile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Eco Hub'),
        automaticallyImplyLeading: false,
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
                Row(
                  children: [
                    const Icon(Icons.eco, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Eco Score',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 14),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Rank #${eco.leaderboardRank}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ScoreStat(value: '${eco.ecoPoints}', label: 'Eco Points'),
                    const SizedBox(width: 24),
                    _ScoreStat(
                        value: '${eco.co2SavedKg.toStringAsFixed(1)} kg',
                        label: 'CO₂ Saved'),
                    const SizedBox(width: 24),
                    _ScoreStat(
                        value: '${eco.carbonCredits}',
                        label: 'Carbon Credits'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              final action = _actions[index];
              return GestureDetector(
                onTap: () => context.push(action.route),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(action.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text(
                        action.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  const _ScoreStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}

class _EcoAction {
  const _EcoAction({required this.emoji, required this.label, required this.route});

  final String emoji;
  final String label;
  final String route;
}
