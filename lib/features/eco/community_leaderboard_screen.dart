import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/eco_model.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/providers/eco_providers.dart';

class CommunityLeaderboardScreen extends ConsumerStatefulWidget {
  const CommunityLeaderboardScreen({super.key});

  @override
  ConsumerState<CommunityLeaderboardScreen> createState() =>
      _CommunityLeaderboardScreenState();
}

class _CommunityLeaderboardScreenState
    extends ConsumerState<CommunityLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _periods = ['weekly', 'monthly', 'allTime'];
  static const _labels = ['Weekly', 'Monthly', 'All Time'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.outline,
          indicatorColor: AppColors.primary,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _periods
            .map((period) => _LeaderboardTab(period: period))
            .toList(),
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  const _LeaderboardTab({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final entries = ref.watch(leaderboardProvider(period));

    if (entries.isEmpty) {
      return const Center(
        child: Text('No entries yet',
            style: TextStyle(color: AppColors.outline)),
      );
    }

    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    // Sort podium: 2nd, 1st, 3rd
    final podiumOrder = <LeaderboardEntry>[];
    if (top3.length >= 2) podiumOrder.add(top3[1]);
    if (top3.isNotEmpty) podiumOrder.add(top3[0]);
    if (top3.length >= 3) podiumOrder.add(top3[2]);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Podium section
        if (top3.isNotEmpty) ...[
          const Text(
            'Top 3',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: podiumOrder.map((entry) {
              final isFirst = entry.rank == 1;
              final medal = entry.rank == 1
                  ? '🥇'
                  : entry.rank == 2
                      ? '🥈'
                      : '🥉';
              final podiumColor = entry.rank == 1
                  ? const Color(0xFFFFC107)
                  : entry.rank == 2
                      ? const Color(0xFFB0BEC5)
                      : const Color(0xFFCD7F32);
              return Expanded(
                child: Column(
                  children: [
                    Text(medal, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: podiumColor.withValues(alpha: 0.2),
                        border: Border.all(color: podiumColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          entry.avatarEmoji ??
                              entry.displayName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.displayName.split(' ').first,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${entry.ecoPoints} pts',
                      style: TextStyle(
                        color: podiumColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: isFirst ? 60 : 40,
                      decoration: BoxDecoration(
                        color: podiumColor.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                      child: Center(
                        child: Text(
                          '#${entry.rank}',
                          style: TextStyle(
                            color: podiumColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.outline, height: 1),
          const SizedBox(height: 12),
        ],

        // Ranked list
        ...rest.map((entry) {
          final isCurrentUser = entry.userId == currentUser.uid;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: isCurrentUser
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '#${entry.rank}',
                    style: TextStyle(
                      color: entry.rank <= 3
                          ? AppColors.primary
                          : AppColors.outline,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    entry.avatarEmoji ??
                        (entry.displayName.isNotEmpty
                            ? entry.displayName[0].toUpperCase()
                            : '?'),
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.displayName,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (entry.badge.isNotEmpty)
                        Text(entry.badge,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 11)),
                    ],
                  ),
                ),
                Text(
                  '${entry.ecoPoints} pts',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
