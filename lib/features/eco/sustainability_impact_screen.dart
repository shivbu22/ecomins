import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';

class SustainabilityImpactScreen extends ConsumerWidget {
  const SustainabilityImpactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eco = ref.watch(currentUserProvider).ecoProfile;
    final co2 = eco.co2SavedKg;
    const wasteDiverted = 28.6;
    final treesEquiv = (co2 / 21).clamp(0.0, double.infinity);
    final nextBadgeProgress = (eco.ecoPoints % 500) / 500.0;
    final pointsToNext = 500 - (eco.ecoPoints % 500);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Sustainability Impact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Impact card shared!')),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Personal stats header
          Row(
            children: [
              Expanded(
                child: _BigStatCard(
                  emoji: '☁️',
                  value: '${co2.toStringAsFixed(1)} kg',
                  label: 'CO₂ Saved',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BigStatCard(
                  emoji: '♻️',
                  value: '${wasteDiverted.toStringAsFixed(1)} kg',
                  label: 'Waste Diverted',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BigStatCard(
                  emoji: '🌳',
                  value: treesEquiv.toStringAsFixed(1),
                  label: 'Trees Equiv.',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress toward next badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Next Badge',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$pointsToNext pts to go',
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: nextBadgeProgress,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${eco.ecoPoints} pts',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      '🏆 Eco Champion',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Impact timeline
          const Text(
            'Impact Timeline',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...MockData.bookings.where((b) => b.serviceId.contains('recycling') || b.serviceId.contains('cleaning')).take(3).map((b) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(b.serviceIcon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.serviceName,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          b.scheduledAt.toString().substring(0, 10),
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '-2.4 kg CO₂',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '+20 pts',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Community stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Impact',
                  style: TextStyle(
                    color: AppColors.onTertiaryContainer,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                _CommunityStatRow(
                    emoji: '☁️', label: 'Total CO₂ Saved', value: '1,240 kg'),
                _CommunityStatRow(
                    emoji: '♻️', label: 'Waste Diverted', value: '3,800 kg'),
                _CommunityStatRow(
                    emoji: '👥', label: 'Active Users', value: '2,400+'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  const _BigStatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  final String emoji;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _CommunityStatRow extends StatelessWidget {
  const _CommunityStatRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  color: AppColors.onTertiaryContainer, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
