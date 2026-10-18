import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/providers/auth_providers.dart';

/// Community eco impact card shown on home screen with animated counters.
class EcoImpactCard extends ConsumerStatefulWidget {
  const EcoImpactCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  ConsumerState<EcoImpactCard> createState() => _EcoImpactCardState();
}

class _EcoImpactCardState extends ConsumerState<EcoImpactCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.public, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text('🌍 Community Impact Today',
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Row(
                  children: [
                    _AnimatedStat(
                      value: (142.3 * _animation.value),
                      label: 'CO₂ Saved',
                      suffix: ' kg',
                      decimals: 1,
                    ),
                    const SizedBox(width: 20),
                    _AnimatedStat(
                      value: (47 * _animation.value),
                      label: 'Services',
                      suffix: '',
                      decimals: 0,
                    ),
                    const SizedBox(width: 20),
                    _AnimatedStat(
                      value: (12 * _animation.value),
                      label: 'Workers Active',
                      suffix: '',
                      decimals: 0,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Your contribution: ${user.ecoProfile.co2SavedKg.toStringAsFixed(1)} kg CO₂',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedStat extends StatelessWidget {
  const _AnimatedStat({
    required this.value,
    required this.label,
    required this.suffix,
    required this.decimals,
  });

  final double value;
  final String label;
  final String suffix;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${value.toStringAsFixed(decimals)}$suffix',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 11)),
      ],
    );
  }
}
