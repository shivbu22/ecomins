import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoStreakScreen extends StatefulWidget {
  const EcoStreakScreen({super.key});

  @override
  State<EcoStreakScreen> createState() => _EcoStreakScreenState();
}

class _EcoStreakScreenState extends State<EcoStreakScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  // Mock: which days in last 30 were active
  final Set<int> _activeDays = {1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 15, 18, 20, 22, 25};

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Your Eco Streak 🔥'),
        actions: [
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Streak shared!')),
            ),
            icon: const Icon(Icons.share_outlined,
                color: AppColors.primary, size: 18),
            label: const Text('Share',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.background,
                    ],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 48)),
                    Text(
                      '7 Days',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Current Streak',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last 30 Days',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, i) {
                    final active = _activeDays.contains(i + 1);
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceContainerLow,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    _Legend(color: AppColors.primary, label: 'Active'),
                    SizedBox(width: 16),
                    _Legend(
                        color: AppColors.surfaceContainerLow,
                        label: 'Missed'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Milestones',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._milestones.map((m) => _MilestoneTile(
                days: m.$1,
                label: m.$2,
                reached: m.$1 <= 7,
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Text('💪', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Keep it going! You\'re on a 7-day streak. Just 7 more days to reach the next milestone!',
                    style: TextStyle(
                        color: AppColors.onSurface, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _milestones = [
  (7, '🔥 Week Warrior'),
  (14, '⚡ Fortnight Fighter'),
  (30, '🌟 Monthly Master'),
  (60, '💎 Diamond Streak'),
  (100, '🏆 Century Champion'),
];

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile(
      {required this.days, required this.label, required this.reached});
  final int days;
  final String label;
  final bool reached;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: reached
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: reached
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Text(
            '$days days',
            style: TextStyle(
              color: reached ? AppColors.primary : AppColors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (reached)
            const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
          else
            const Icon(Icons.lock_outline,
                color: AppColors.outline, size: 20),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 11)),
      ],
    );
  }
}
