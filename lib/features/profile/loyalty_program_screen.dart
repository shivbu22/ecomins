import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class LoyaltyProgramScreen extends StatelessWidget {
  const LoyaltyProgramScreen({super.key});

  static const _tiers = [
    _Tier(emoji: '🥉', name: 'Bronze', multiplier: '1x', support: 'Basic support', extra: ''),
    _Tier(emoji: '🥈', name: 'Silver', multiplier: '1.5x', support: 'Priority support', extra: 'Monthly bonus'),
    _Tier(emoji: '🥇', name: 'Gold', multiplier: '2x', support: 'Dedicated support', extra: 'Free monthly service'),
    _Tier(emoji: '💎', name: 'Platinum', multiplier: '3x', support: 'VIP support', extra: 'Weekly free service'),
  ];

  static const _history = [
    _PointTx(desc: 'Cleaning service booked', points: '+20', date: '24 Oct'),
    _PointTx(desc: 'Recycling pickup', points: '+50', date: '22 Oct'),
    _PointTx(desc: 'Referral bonus', points: '+200', date: '20 Oct'),
    _PointTx(desc: 'Eco challenge completed', points: '+100', date: '18 Oct'),
    _PointTx(desc: 'Reward redeemed', points: '-500', date: '15 Oct'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Loyalty Program'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current tier card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC0C0C0).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🥈', style: TextStyle(fontSize: 32)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Silver Member', style: TextStyle(color: Color(0xFFC0C0C0), fontSize: 20, fontWeight: FontWeight.w800)),
                        Text('1,250 eco points', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Progress to Gold', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 1250 / 2000,
                    backgroundColor: AppColors.surfaceContainerLow,
                    valueColor: AlwaysStoppedAnimation(Color(0xFFFFD700)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('750 more points to Gold', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tier Benefits', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._tiers.map((t) => _TierCard(tier: t, isCurrent: t.name == 'Silver')),
          const SizedBox(height: 24),
          const Text('Points History', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: _history.map((tx) => _PointTxTile(tx: tx)).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _HowToEarnSection(),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier, required this.isCurrent});
  final _Tier tier;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? AppColors.primary : AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(tier.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tier.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                        child: const Text('Current', style: TextStyle(color: AppColors.onPrimary, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                Text('${tier.multiplier} points • ${tier.support}${tier.extra.isNotEmpty ? ' • ${tier.extra}' : ''}',
                    style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointTxTile extends StatelessWidget {
  const _PointTxTile({required this.tx});
  final _PointTx tx;

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.points.startsWith('+');
    return ListTile(
      title: Text(tx.desc, style: const TextStyle(color: AppColors.onSurface, fontSize: 14)),
      subtitle: Text(tx.date, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
      trailing: Text(
        tx.points,
        style: TextStyle(
          color: isCredit ? AppColors.primary : AppColors.error,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _HowToEarnSection extends StatefulWidget {
  @override
  State<_HowToEarnSection> createState() => _HowToEarnSectionState();
}

class _HowToEarnSectionState extends State<_HowToEarnSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          ListTile(
            title: const Text('How to earn more points', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
            trailing: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.outline),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EarnTip(emoji: '🧹', tip: 'Book services — earn 10-50 pts per booking'),
                  _EarnTip(emoji: '♻️', tip: 'Recycle — earn 50 pts per pickup'),
                  _EarnTip(emoji: '👥', tip: 'Refer friends — earn 200 pts per referral'),
                  _EarnTip(emoji: '🎯', tip: 'Complete challenges — earn 100-500 pts'),
                  _EarnTip(emoji: '⭐', tip: 'Rate services — earn 5 pts per review'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EarnTip extends StatelessWidget {
  const _EarnTip({required this.emoji, required this.tip});
  final String emoji;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13))),
        ],
      ),
    );
  }
}

class _Tier {
  const _Tier({required this.emoji, required this.name, required this.multiplier, required this.support, required this.extra});
  final String emoji;
  final String name;
  final String multiplier;
  final String support;
  final String extra;
}

class _PointTx {
  const _PointTx({required this.desc, required this.points, required this.date});
  final String desc;
  final String points;
  final String date;
}
