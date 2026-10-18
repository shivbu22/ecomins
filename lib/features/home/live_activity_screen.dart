import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class LiveActivityScreen extends StatefulWidget {
  const LiveActivityScreen({super.key});

  @override
  State<LiveActivityScreen> createState() => _LiveActivityScreenState();
}

class _LiveActivityScreenState extends State<LiveActivityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<_ActivityItem> _activities = [
    const _ActivityItem(
        text: 'Meera just booked Home Cleaning',
        time: '2 min ago',
        emoji: '🧹'),
    const _ActivityItem(
        text: 'Ravi Kumar completed a Deep Clean',
        time: '5 min ago',
        emoji: '✅'),
    const _ActivityItem(
        text: '12 workers are active right now',
        time: 'Live',
        emoji: '👷'),
    const _ActivityItem(
        text: 'Ananya earned 50 eco points',
        time: '8 min ago',
        emoji: '⭐'),
    const _ActivityItem(
        text: 'Community saved 2.3kg CO₂ today',
        time: 'Today',
        emoji: '🌿'),
    const _ActivityItem(
        text: 'Vikram booked Garden Care',
        time: '11 min ago',
        emoji: '🌱'),
    const _ActivityItem(
        text: 'Priya Devi completed Garbage Pickup',
        time: '14 min ago',
        emoji: '🗑️'),
    const _ActivityItem(
        text: 'Sneha recycled 5kg of paper',
        time: '18 min ago',
        emoji: '♻️'),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: _pulseAnim.value),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Live in Koramangala 🟢'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            color: AppColors.surfaceContainerLow,
            child: const Row(
              children: [
                _LiveStat(value: '12', label: 'Workers Active'),
                SizedBox(width: 16),
                _LiveStat(value: '47', label: 'Services Today'),
                SizedBox(width: 16),
                _LiveStat(value: '14.2kg', label: 'CO₂ Saved'),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final item = _activities[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x333C4A3C)),
                  ),
                  child: Row(
                    children: [
                      Text(item.emoji,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(item.text,
                            style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 13)),
                      ),
                      Text(item.time,
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),

          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/eco/leaderboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Join the community 🌿',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String text, time, emoji;
  const _ActivityItem(
      {required this.text, required this.time, required this.emoji});
}

class _LiveStat extends StatelessWidget {
  const _LiveStat({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 10)),
        ],
      ),
    );
  }
}
