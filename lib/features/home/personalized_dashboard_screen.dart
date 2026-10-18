import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';

class PersonalizedDashboardScreen extends ConsumerWidget {
  const PersonalizedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Your Eco Journey 🌍'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // This week stats
          const Text('This Week',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: const [
              _StatCard(
                  emoji: '📦',
                  value: '3',
                  label: 'Services Booked',
                  trend: '+1'),
              _StatCard(
                  emoji: '🌿',
                  value: '8.2 kg',
                  label: 'CO₂ Saved',
                  trend: '+2.1'),
              _StatCard(
                  emoji: '⭐',
                  value: '180',
                  label: 'Eco Points',
                  trend: '+50'),
              _StatCard(
                  emoji: '💰',
                  value: '₹150',
                  label: 'Money Saved',
                  trend: '+₹50'),
            ],
          ),
          const SizedBox(height: 20),

          // Streak card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A1A00), Color(0xFF1A0D00)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('7 day streak — Keep going!',
                          style: TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      Text('You\'re on a roll! Book today to continue.',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Next milestone
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Next Milestone',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('150 more points to reach Gold tier',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 13)),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: user.ecoProfile.ecoPoints / 1400,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${user.ecoProfile.ecoPoints} pts',
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 12)),
                    const Text('1400 pts (Gold)',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress ring + recommended action
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: user.ecoProfile.ecoPoints / 2000,
                      strokeWidth: 10,
                      backgroundColor:
                          AppColors.surfaceContainerLow,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(user.ecoProfile.ecoPoints / 2000 * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        const Text('Goal',
                            style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recommended next action',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11)),
                      const SizedBox(height: 4),
                      const Text(
                          'Book recycling pickup to earn 50 pts',
                          style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            context.push('/book/recycling_paper'),
                        child: const Text('Book Now →',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick stats
          const Text('All Time',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                  child: _QuickStat(
                      label: 'Total Bookings', value: '12')),
              SizedBox(width: 10),
              Expanded(
                  child: _QuickStat(
                      label: 'Total Spent', value: '₹4,200')),
              SizedBox(width: 10),
              Expanded(
                  child: _QuickStat(
                      label: 'Trees Planted', value: '3 🌳')),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.trend,
  });

  final String emoji, value, label, trend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10)),
          Row(
            children: [
              const Icon(Icons.arrow_upward,
                  color: AppColors.primary, size: 11),
              Text(trend,
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10)),
        ],
      ),
    );
  }
}
