import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class DeepCleanDetailScreen extends ConsumerStatefulWidget {
  const DeepCleanDetailScreen({super.key});

  @override
  ConsumerState<DeepCleanDetailScreen> createState() =>
      _DeepCleanDetailScreenState();
}

class _DeepCleanDetailScreenState extends ConsumerState<DeepCleanDetailScreen> {
  final Set<String> _selectedRooms = {'Gourmet Kitchen'};
  String? _selectedSpecialistId;

  static const _rooms = [
    'Gourmet Kitchen',
    'Bathrooms',
    'Bedroom',
    'Living & Dining',
    'Study Room',
    'Balcony',
  ];

  static const _specialists = [
    {
      'id': 'worker_001',
      'emoji': '👷',
      'name': 'Ravi Kumar',
      'rating': '4.9',
      'skills': ['Deep Clean', 'Eco Certified'],
      'addon': 149.0,
    },
    {
      'id': 'worker_002',
      'emoji': '👩',
      'name': 'Priya Devi',
      'rating': '4.8',
      'skills': ['Sanitization', 'Bio-Enzymatic'],
      'addon': 129.0,
    },
    {
      'id': 'worker_003',
      'emoji': '👨',
      'name': 'Suresh Babu',
      'rating': '4.7',
      'skills': ['Scrubbing', 'Eco Friendly'],
      'addon': 99.0,
    },
  ];

  double get _specialistAddon {
    if (_selectedSpecialistId == null) return 0;
    final s = _specialists.firstWhere(
      (s) => s['id'] == _selectedSpecialistId,
      orElse: () => {},
    );
    return (s['addon'] as double?) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    const serviceFee = 799.0;
    const ecoCredit = 40.0;
    final total = serviceFee + _specialistAddon - ecoCredit;

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
          'Service',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proceeding to booking...')),
        ),
        child: const Icon(Icons.arrow_forward_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          // Hero section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text('🧴', style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text(
                  'Deep Clean Detail',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hyper-precise ecological sanitation',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.access_time_rounded,
                        label: 'Duration',
                        value: '4.5 - 6 Hours',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.cleaning_services_rounded,
                        label: 'Intensity',
                        value: 'Pro Scrubbing',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Room selection
          const Text(
            'Select Rooms',
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
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: _rooms.length,
            itemBuilder: (context, index) {
              final room = _rooms[index];
              final selected = _selectedRooms.contains(room);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _selectedRooms.remove(room);
                  } else {
                    _selectedRooms.add(room);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (selected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 18)
                      else
                        const Icon(Icons.radio_button_unchecked,
                            color: AppColors.outline, size: 18),
                      const SizedBox(height: 4),
                      Text(
                        room,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Eco-Agents section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1F0D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🌿', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Green-Tech Agents',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Ph-neutral, Bio-enzymatic formulas',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '85%',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Specialist selection
          const Text(
            'Choose Specialist',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _specialists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final s = _specialists[index];
                final isSelected = _selectedSpecialistId == s['id'];
                return _SpecialistCard(
                  specialist: s,
                  isSelected: isSelected,
                  onSelect: () => setState(() {
                    _selectedSpecialistId =
                        isSelected ? null : s['id'] as String;
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Price breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const _PriceRow(label: 'Service Fee', amount: serviceFee),
                if (_specialistAddon > 0)
                  _PriceRow(
                      label: 'Specialist Add-on', amount: _specialistAddon),
                const _PriceRow(
                    label: 'Eco Credit',
                    amount: -ecoCredit,
                    isDiscount: true),
                const Divider(color: AppColors.outline, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
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
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialistCard extends StatelessWidget {
  const _SpecialistCard({
    required this.specialist,
    required this.isSelected,
    required this.onSelect,
  });

  final Map<String, dynamic> specialist;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final skills = specialist['skills'] as List;
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(specialist['emoji'] as String,
              style: const TextStyle(fontSize: 32)),
          Text(
            specialist['name'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 12),
              const SizedBox(width: 2),
              Text(
                specialist['rating'] as String,
                style: const TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 11),
              ),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: skills
                .take(2)
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        s as String,
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 9),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainer,
                foregroundColor: isSelected
                    ? AppColors.onPrimary
                    : AppColors.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                isSelected ? 'Selected' : 'Select',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
  });

  final String label;
  final double amount;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
          Text(
            isDiscount
                ? '- ₹${amount.abs().toStringAsFixed(0)}'
                : '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: isDiscount ? AppColors.primary : AppColors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
