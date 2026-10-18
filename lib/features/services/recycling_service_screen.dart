import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class RecyclingServiceScreen extends ConsumerStatefulWidget {
  const RecyclingServiceScreen({super.key});

  @override
  ConsumerState<RecyclingServiceScreen> createState() =>
      _RecyclingServiceScreenState();
}

class _RecyclingServiceScreenState
    extends ConsumerState<RecyclingServiceScreen> {
  final Set<String> _selectedMaterials = {'Plastic'};
  String _selectedSlot = 'Today 2PM';

  static const _materials = [
    {'name': 'Plastic', 'emoji': '♻️', 'rate': '+12/kg'},
    {'name': 'Paper', 'emoji': '📄', 'rate': '+8/kg'},
    {'name': 'Metal', 'emoji': '⚙️', 'rate': '+25/kg'},
    {'name': 'Glass', 'emoji': '🍷', 'rate': '+15/kg'},
    {'name': 'E-Waste', 'emoji': '📱', 'rate': '+50/kg'},
    {'name': 'Other', 'emoji': '➕', 'rate': 'Varies'},
  ];

  static const _timeSlots = [
    'Today 2PM',
    'Tomorrow',
    'Thursday',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
          onPressed: () {},
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recycle Hub',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Ecomins',
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3FE56C), Color(0xFF1A8C3F)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pickup confirmed!')),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Confirm Pickup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero earnings card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimated Earnings',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 6),
                const Text(
                  '1,240 Eco-Credits',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.80,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '80% of monthly goal',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Material selection
          const Text(
            'Select Materials',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: _materials.length,
            itemBuilder: (context, index) {
              final m = _materials[index];
              final name = m['name']!;
              final selected = _selectedMaterials.contains(name);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _selectedMaterials.remove(name);
                  } else {
                    _selectedMaterials.add(name);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.outline.withValues(alpha: 0.3),
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(m['emoji']!,
                          style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        m['rate']!,
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Schedule pickup
          const Text(
            'Schedule Pickup',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _timeSlots.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final slot = _timeSlots[index];
                final selected = _selectedSlot == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSlot = slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Live tracking
          const Text(
            'Live Tracking',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1A0D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Stack(
              children: [
                // Map placeholder
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PulseDot(),
                      const SizedBox(height: 8),
                      const Text(
                        'Squad #42 (Mike)',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        '0.8 miles away • 4 min',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 12),
                      ),
                    ],
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

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: _animation.value),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: _animation.value * 0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
