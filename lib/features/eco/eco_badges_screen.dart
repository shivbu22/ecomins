import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoBadgesScreen extends StatelessWidget {
  const EcoBadgesScreen({super.key});

  static const _earned = [
    _Badge(emoji: '🌱', name: 'Eco Starter', desc: 'Booked your first eco service', date: '15 Sep 2024', locked: false),
    _Badge(emoji: '♻️', name: 'Recycler', desc: 'Recycled 10 times', date: '2 Oct 2024', locked: false),
    _Badge(emoji: '🏆', name: 'Top 50', desc: 'Reached top 50 on leaderboard', date: '20 Oct 2024', locked: false),
  ];

  static const _locked = [
    _Badge(emoji: '🌍', name: 'Carbon Neutral', desc: 'Offset 5 tonnes of CO₂', date: '', locked: true),
    _Badge(emoji: '🥇', name: 'Eco Champion', desc: 'Reach top 10 on leaderboard', date: '', locked: true),
    _Badge(emoji: '💎', name: 'Diamond Eco', desc: 'Earn 10,000 eco points', date: '', locked: true),
  ];

  void _showBadgeDetail(BuildContext context, _Badge badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(badge.name, style: const TextStyle(color: AppColors.onSurface, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(badge.desc, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14), textAlign: TextAlign.center),
            if (!badge.locked && badge.date.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Earned on ${badge.date}', style: const TextStyle(color: AppColors.primary, fontSize: 13)),
            ],
            if (badge.locked) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Keep using Ecomins to unlock this badge!',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13), textAlign: TextAlign.center),
              ),
            ],
            const SizedBox(height: 20),
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
        title: const Text('My Badges'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Earned Badges',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _earned.length,
            itemBuilder: (context, i) => _BadgeCard(badge: _earned[i], onTap: () => _showBadgeDetail(context, _earned[i])),
          ),
          const SizedBox(height: 24),
          const Text('Locked Badges',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _locked.length,
            itemBuilder: (context, i) => _BadgeCard(badge: _locked[i], onTap: () => _showBadgeDetail(context, _locked[i])),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.onTap});
  final _Badge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: badge.locked ? AppColors.surfaceContainer.withValues(alpha: 0.5) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: badge.locked ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 40,
                    color: badge.locked ? Colors.grey : null,
                  ),
                ),
                if (badge.locked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: AppColors.surfaceContainerLow, shape: BoxShape.circle),
                      child: const Icon(Icons.lock, color: AppColors.outline, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              badge.name,
              style: TextStyle(
                color: badge.locked ? AppColors.outline : AppColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.desc,
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!badge.locked && badge.date.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(badge.date, style: const TextStyle(color: AppColors.primary, fontSize: 10)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Badge {
  const _Badge({required this.emoji, required this.name, required this.desc, required this.date, required this.locked});
  final String emoji;
  final String name;
  final String desc;
  final String date;
  final bool locked;
}
