import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class SmartSchedulingScreen extends ConsumerStatefulWidget {
  const SmartSchedulingScreen({super.key});

  @override
  ConsumerState<SmartSchedulingScreen> createState() =>
      _SmartSchedulingScreenState();
}

class _SmartSchedulingScreenState
    extends ConsumerState<SmartSchedulingScreen> {
  bool _isImmediate = true;
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;
  String? _selectedRecurrence;

  static const _timeSlots = [
    {'id': 'morning', 'label': 'Morning', 'sub': '8 AM – 12 PM', 'emoji': '🌅'},
    {'id': 'afternoon', 'label': 'Afternoon', 'sub': '12 PM – 4 PM', 'emoji': '☀️'},
    {'id': 'evening', 'label': 'Evening', 'sub': '4 PM – 8 PM', 'emoji': '🌆'},
  ];

  static const _recurrences = ['Daily', 'Weekly', 'Monthly'];

  static const _suggestions = [
    {'emoji': '⭐', 'label': 'Tuesday 10 AM', 'sub': 'Your usual slot'},
    {'emoji': '🔥', 'label': 'Saturday 9 AM', 'sub': 'Popular time'},
  ];

  List<String> get _dateLabels {
    final now = DateTime.now();
    return [
      'Today',
      'Tomorrow',
      _dayName(now.add(const Duration(days: 2))),
    ];
  }

  String _dayName(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }

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
          'Smart Scheduling',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Schedule confirmed!')),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Confirm Schedule',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'When do you need it?',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // Immediate option
          GestureDetector(
            onTap: () => setState(() => _isImmediate = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isImmediate
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isImmediate ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isImmediate
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('⚡', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Now',
                          style: TextStyle(
                            color: _isImmediate
                                ? AppColors.primary
                                : AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Arriving in ~10 mins',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (_isImmediate)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Scheduled section
          GestureDetector(
            onTap: () => setState(() => _isImmediate = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: !_isImmediate
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !_isImmediate ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: !_isImmediate
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('📅', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Schedule for Later',
                        style: TextStyle(
                          color: !_isImmediate
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (!_isImmediate) ...[
                    const SizedBox(height: 16),
                    // Date picker row
                    Row(
                      children: List.generate(_dateLabels.length, (i) {
                        final selected = _selectedDateIndex == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDateIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  _dateLabels[i],
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.onPrimary
                                        : AppColors.onSurfaceVariant,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    // Time slot grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = _timeSlots[index];
                        final selected = _selectedTimeSlot == slot['id'];
                        return GestureDetector(
                          onTap: () => setState(
                              () => _selectedTimeSlot = slot['id']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(slot['emoji']!,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 4),
                                Text(
                                  slot['label']!,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.onSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  slot['sub']!,
                                  style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recurring section
          const Text(
            'Recurring',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: _recurrences.map((r) {
              final selected = _selectedRecurrence == r;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedRecurrence = selected ? null : r;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      r,
                      style: TextStyle(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Smart suggestions
          const Text(
            'Smart Suggestions',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Based on your history',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ..._suggestions.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(s['emoji']!,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['label']!,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            s['sub']!,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _isImmediate = false;
                      }),
                      child: const Text(
                        'Use',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
