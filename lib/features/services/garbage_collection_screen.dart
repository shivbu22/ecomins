import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class GarbageCollectionScreen extends ConsumerStatefulWidget {
  const GarbageCollectionScreen({super.key});

  @override
  ConsumerState<GarbageCollectionScreen> createState() =>
      _GarbageCollectionScreenState();
}

class _GarbageCollectionScreenState
    extends ConsumerState<GarbageCollectionScreen> {
  String _selectedCategory = 'dry';
  String _selectedPlan = 'weekly';

  static const _categories = [
    {
      'id': 'dry',
      'emoji': '📦',
      'label': 'Dry Waste',
      'sub': 'Paper, Plastic, Metal',
    },
    {
      'id': 'wet',
      'emoji': '🥬',
      'label': 'Wet Waste',
      'sub': 'Food leftovers, Organic',
    },
    {
      'id': 'biohazard',
      'emoji': '⚠️',
      'label': 'Bio-Hazard',
      'sub': 'Medical, Chemical, Sharp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Garbage Collection',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
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
                const SnackBar(content: Text('Garbage collection scheduled!')),
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
                'Schedule Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Impact radar banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Text('🌍', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '14.2kg CO₂ Offset by your neighborhood today',
                    style: TextStyle(
                      color: AppColors.onTertiaryContainer,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live status grid
          const Row(
            children: [
              Expanded(
                child: _StatusCard(
                  icon: Icons.access_time_rounded,
                  label: 'Next Pickup',
                  value: '14 Mins',
                  valueColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  icon: Icons.verified_user_outlined,
                  label: 'Eco-Squad',
                  value: 'Unit #0429',
                  valueColor: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category selection
          const Text(
            'Waste Category',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._categories.map((cat) {
            final selected = _selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () =>
                  setState(() => _selectedCategory = cat['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(cat['emoji'] as String,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat['label'] as String,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            cat['sub'] as String,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.outline,
                          width: 2,
                        ),
                      ),
                      child: selected
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Scheduling options
          const Text(
            'Scheduling',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _PlanCard(
            id: 'weekly',
            title: 'Weekly Cycle',
            subtitle: 'Mon / Wed / Fri',
            price: '₹12/mo',
            isRecommended: true,
            isSelected: _selectedPlan == 'weekly',
            onTap: () => setState(() => _selectedPlan = 'weekly'),
            chips: const ['Mon', 'Wed', 'Fri'],
          ),
          const SizedBox(height: 10),
          _PlanCard(
            id: 'daily',
            title: 'Daily Collection',
            subtitle: 'Every day pickup',
            price: '₹29/mo',
            isRecommended: false,
            isPremium: true,
            isSelected: _selectedPlan == 'daily',
            onTap: () => setState(() => _selectedPlan = 'daily'),
            chips: const [],
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

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
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isRecommended,
    required this.isSelected,
    required this.onTap,
    required this.chips,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String price;
  final bool isRecommended;
  final bool isPremium;
  final bool isSelected;
  final VoidCallback onTap;
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                if (isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Recommended',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 10),
                    ),
                  ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Premium',
                      style: TextStyle(
                          color: Color(0xFFFFC107), fontSize: 10),
                    ),
                  ),
                const Spacer(),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            if (chips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: chips
                    .map((c) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 11),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
