import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class EcoGoalsScreen extends StatefulWidget {
  const EcoGoalsScreen({super.key});

  @override
  State<EcoGoalsScreen> createState() => _EcoGoalsScreenState();
}

class _EcoGoalsScreenState extends State<EcoGoalsScreen> {
  final List<_Goal> _activeGoals = [
    const _Goal(
        title: 'Save 50kg CO₂ this month',
        current: 34.5,
        target: 50,
        unit: 'kg'),
    const _Goal(
        title: 'Book 10 eco services',
        current: 7,
        target: 10,
        unit: 'services'),
    const _Goal(
        title: 'Earn 2000 eco points',
        current: 1250,
        target: 2000,
        unit: 'pts'),
  ];

  final List<_Goal> _completedGoals = [
    const _Goal(
        title: 'First eco booking',
        current: 1,
        target: 1,
        unit: 'booking',
        completedDate: 'Oct 1'),
    const _Goal(
        title: 'Recycle 5 times',
        current: 5,
        target: 5,
        unit: 'times',
        completedDate: 'Oct 10'),
  ];

  void _showAddGoal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set New Goal',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ('🌿', 'Save CO₂'),
              ('📦', 'Book services'),
              ('⭐', 'Earn eco points'),
              ('🌳', 'Plant trees'),
            ].map(
              (item) => ListTile(
                leading: Text(item.$1,
                    style: const TextStyle(fontSize: 22)),
                title: Text(item.$2,
                    style: const TextStyle(color: AppColors.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${item.$2} goal added!')),
                  );
                },
              ),
            ),
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
        title: const Text('My Eco Goals 🎯'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goals shared! 🌿')),
              );
            },
            icon: const Icon(Icons.share_outlined,
                color: AppColors.primary, size: 18),
            label: const Text('Share',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: _showAddGoal,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Active Goals',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          ..._activeGoals.map(
            (goal) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title,
                      style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor:
                                  (goal.current / goal.target).clamp(0, 1),
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
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(goal.current / goal.target * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${goal.current.toStringAsFixed(goal.current % 1 == 0 ? 0 : 1)} / ${goal.target.toStringAsFixed(0)} ${goal.unit}',
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Completed Goals ✅',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          ..._completedGoals.map(
            (goal) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x333C4A3C)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(goal.title,
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13)),
                  ),
                  Text('Completed ${goal.completedDate}',
                      style: const TextStyle(
                          color: AppColors.outline, fontSize: 11)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '"The Earth does not belong to us, we belong to the Earth." — Chief Seattle',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Goal {
  final String title, unit;
  final double current, target;
  final String? completedDate;

  const _Goal({
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
    this.completedDate,
  });
}
