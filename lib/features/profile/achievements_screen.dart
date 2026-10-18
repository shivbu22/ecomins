import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    const achievements = [
      _Achievement(
          emoji: '🥇',
          title: 'First Booking',
          desc: 'Booked your first service',
          earned: true,
          earnedDate: 'Sep 15'),
      _Achievement(
          emoji: '🌱',
          title: 'Eco Starter',
          desc: 'Completed 5 eco services',
          earned: true,
          earnedDate: 'Sep 28'),
      _Achievement(
          emoji: '♻️',
          title: 'Recycler',
          desc: 'Recycled 10 times',
          earned: true,
          earnedDate: 'Oct 5'),
      _Achievement(
          emoji: '🔥',
          title: '7-Day Streak',
          desc: '7 consecutive days',
          earned: true,
          earnedDate: 'Oct 12'),
      _Achievement(
          emoji: '🌍',
          title: 'Carbon Neutral',
          desc: 'Offset 1 tonne CO₂',
          earned: false,
          progress: 0.6),
      _Achievement(
          emoji: '💎',
          title: 'Diamond Member',
          desc: 'Spend ₹10,000',
          earned: false,
          progress: 0.42),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Achievements 🏆'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          Row(
            children: [
              const _StatChip(value: '12', label: 'Bookings'),
              const SizedBox(width: 8),
              _StatChip(
                  value: '${user.ecoProfile.co2SavedKg.toStringAsFixed(1)}kg',
                  label: 'CO₂'),
              const SizedBox(width: 8),
              _StatChip(
                  value: '${user.ecoProfile.ecoPoints}',
                  label: 'Points'),
              const SizedBox(width: 8),
              const _StatChip(value: '3 🌳', label: 'Trees'),
            ],
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final a = achievements[index];
              return _AchievementCard(achievement: a);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Achievement {
  final String emoji, title, desc;
  final bool earned;
  final String? earnedDate;
  final double? progress;

  const _Achievement({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.earned,
    this.earnedDate,
    this.progress,
  });
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});
  final _Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final a = achievement;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: a.earned
            ? AppColors.surfaceContainer
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: a.earned
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0x333C4A3C),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            a.emoji,
            style: TextStyle(
              fontSize: 36,
              color: a.earned ? null : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(a.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: a.earned
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(a.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          if (a.earned)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Earned ${a.earnedDate}',
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 10)),
            )
          else if (a.progress != null) ...[
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: a.progress,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${(a.progress! * 100).toStringAsFixed(0)}% — keep going!',
              style: const TextStyle(
                  color: AppColors.outline, fontSize: 9),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
