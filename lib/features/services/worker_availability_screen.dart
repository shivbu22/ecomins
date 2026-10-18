import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class WorkerAvailabilityScreen extends StatefulWidget {
  const WorkerAvailabilityScreen({super.key});

  @override
  State<WorkerAvailabilityScreen> createState() => _WorkerAvailabilityScreenState();
}

class _WorkerAvailabilityScreenState extends State<WorkerAvailabilityScreen> {
  int _selectedDay = 0;
  int? _selectedSlot;

  final List<String> _days = ['Today', 'Tomorrow', 'Day After'];

  // Mock availability: slot index -> status (0=available, 1=busy, 2=empty)
  final Map<int, Map<int, int>> _availability = {
    0: {0: 1, 1: 0, 2: 0, 3: 1, 4: 0, 5: 2, 6: 0, 7: 1, 8: 0, 9: 0, 10: 1, 11: 2},
    1: {0: 0, 1: 0, 2: 1, 3: 0, 4: 1, 5: 0, 6: 2, 7: 0, 8: 0, 9: 1, 10: 0, 11: 0},
    2: {0: 2, 1: 0, 2: 0, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 2, 9: 0, 10: 0, 11: 1},
  };

  String _slotLabel(int i) {
    final hour = 8 + i;
    final suffix = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '$displayHour:00 $suffix';
  }

  void _showWorkersForSlot(int slotIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workers available at ${_slotLabel(slotIndex)}',
                style: const TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...MockData.workers.take(2).map((w) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Text(w.avatarEmoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                        Text('Rating: ${w.rating}⭐', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.push('/book/${w.serviceIds.first}');
                    },
                    child: const Text('Book', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/book/${MockData.workers.first.serviceIds.first}');
                },
                child: const Text('Book This Slot', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayAvailability = _availability[_selectedDay] ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Worker Availability'),
      ),
      body: Column(
        children: [
          // Day selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _days.asMap().entries.map((e) {
                final selected = _selectedDay == e.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _selectedDay = e.key; _selectedSlot = null; }),
                    child: Container(
                      margin: EdgeInsets.only(right: e.key < _days.length - 1 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        e.value,
                        style: TextStyle(
                          color: selected ? AppColors.onPrimary : AppColors.onSurface,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Legend
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _LegendDot(color: AppColors.primary, label: 'Available'),
                SizedBox(width: 16),
                _LegendDot(color: AppColors.error, label: 'Busy'),
                SizedBox(width: 16),
                _LegendDot(color: AppColors.outline, label: 'No workers'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Time grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                final status = dayAvailability[i] ?? 2;
                final isAvailable = status == 0;
                final isBusy = status == 1;
                final selected = _selectedSlot == i;

                return GestureDetector(
                  onTap: isAvailable ? () {
                    setState(() => _selectedSlot = i);
                    _showWorkersForSlot(i);
                  } : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_slotLabel(i), style: TextStyle(
                          color: isAvailable ? AppColors.onSurface : AppColors.outline,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAvailable ? AppColors.primary : isBusy ? AppColors.error : AppColors.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
      ],
    );
  }
}
