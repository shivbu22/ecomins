import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';
import 'package:ecomins/shared/widgets/status_chip.dart';

/// Redesigned Eco Hub v2 with tier badge, circular progress, and action grid.
class EcoHubV2Screen extends ConsumerWidget {
  const EcoHubV2Screen({super.key});

  static const _actions = [
    _EcoAction(emoji: '🧮', label: 'Calculator', route: '/eco/calculator'),
    _EcoAction(emoji: '🏅', label: 'Badges', route: '/eco/badges'),
    _EcoAction(emoji: '🎯', label: 'Challenges', route: '/eco/challenges'),
    _EcoAction(emoji: '🎯', label: 'Goals', route: '/eco/goals'),
    _EcoAction(emoji: '🌍', label: 'Offset', route: '/eco/offset'),
    _EcoAction(emoji: '📰', label: 'News', route: '/eco/news'),
    _EcoAction(emoji: '🏆', label: 'Leaderboard', route: '/eco/leaderboard'),
    _EcoAction(emoji: '📅', label: 'Events', route: '/eco/events'),
    _EcoAction(emoji: '🤝', label: 'Volunteer', route: '/eco/volunteer'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final eco = user.ecoProfile;
    final tier = AppUtils.ecoTier(eco.ecoPoints);
    final tierColor = AppUtils.ecoTierColor(eco.ecoPoints);
    final tierEmoji = AppUtils.ecoTierEmoji(eco.ecoPoints);
    final progress = AppUtils.tierProgress(eco.ecoPoints);
    final toNext = AppUtils.pointsToNextTier(eco.ecoPoints);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Text('Eco Hub', style: AppTextStyles.h3),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => context.push('/eco/report'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Personal eco score card ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.primaryCard(radius: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Circular progress
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  tierColor),
                            ),
                          ),
                          Text(tierEmoji,
                              style: const TextStyle(fontSize: 28)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(user.name.split(' ').first,
                                  style: AppTextStyles.h3),
                              const SizedBox(width: 8),
                              StatusChip(
                                label: tier,
                                color: tierColor,
                                emoji: tierEmoji,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${eco.ecoPoints} eco points',
                            style: AppTextStyles.price,
                          ),
                          if (toNext > 0)
                            Text(
                              '$toNext pts to next tier',
                              style: AppTextStyles.bodySmall,
                            ),
                          Text(
                            'Rank #${eco.leaderboardRank}',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick stats row
                Row(
                  children: [
                    _QuickStat(
                        value: '${eco.ecoPoints}',
                        label: 'Points',
                        emoji: '🌿'),
                    _QuickStat(
                        value: '${eco.co2SavedKg.toStringAsFixed(1)}kg',
                        label: 'CO₂',
                        emoji: '🌍'),
                    _QuickStat(
                        value: '${eco.carbonCredits}',
                        label: 'Credits',
                        emoji: '🌳'),
                    const _QuickStat(
                        value: '7',
                        label: 'Day Streak',
                        emoji: '🔥'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── This week's challenge ────────────────────────────────────
          GestureDetector(
            onTap: () => context.push('/eco/challenges'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.glowCard(),
              child: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("This Week's Challenge",
                            style: AppTextStyles.label.copyWith(
                                color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text('Recycle 5 items this week',
                            style: AppTextStyles.h4),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('3/5 completed · +150 pts reward',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.outline, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Action grid (3 cols) ─────────────────────────────────────
          Text('Quick Actions', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              final action = _actions[index];
              return GestureDetector(
                onTap: () => context.push(action.route),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecorations.card(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(action.emoji,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(
                        action.label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // ── Recent eco activity ──────────────────────────────────────
          Text('Recent Activity', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          ..._recentActivity.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: AppDecorations.card(),
                child: Row(
                  children: [
                    Text(a['emoji']!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title']!, style: AppTextStyles.bodyMedium),
                          Text(a['time']!, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Text(a['points']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  static const _recentActivity = [
    {'emoji': '♻️', 'title': 'Paper Recycling', 'time': '2 hours ago', 'points': '+50 pts'},
    {'emoji': '🧹', 'title': 'Home Cleaning', 'time': 'Yesterday', 'points': '+20 pts'},
    {'emoji': '🗑️', 'title': 'Garbage Pickup', 'time': '2 days ago', 'points': '+15 pts'},
  ];
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.value,
    required this.label,
    required this.emoji,
  });

  final String value;
  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              )),
          Text(label,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10)),
        ],
      ),
    );
  }
}

class _EcoAction {
  const _EcoAction({
    required this.emoji,
    required this.label,
    required this.route,
  });

  final String emoji;
  final String label;
  final String route;
}
