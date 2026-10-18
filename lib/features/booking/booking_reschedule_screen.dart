import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/data/models/booking_model.dart';

class BookingRescheduleScreen extends StatefulWidget {
  const BookingRescheduleScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<BookingRescheduleScreen> createState() => _BookingRescheduleScreenState();
}

class _BookingRescheduleScreenState extends State<BookingRescheduleScreen> {
  int _selectedDayIndex = 0;
  String _selectedSlot = '';

  final List<String> _timeSlots = ['Morning (8–12)', 'Afternoon (12–4)', 'Evening (4–8)'];

  BookingModel? get _booking {
    try {
      return MockData.bookings.firstWhere((b) => b.id == widget.bookingId);
    } catch (_) {
      return MockData.bookings.isNotEmpty ? MockData.bookings.first : null;
    }
  }

  List<DateTime> get _next7Days {
    final now = DateTime.now();
    return List.generate(7, (i) => now.add(Duration(days: i + 1)));
  }

  String _dayLabel(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }

  void _confirm() {
    if (_selectedSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking rescheduled!'),
        backgroundColor: AppColors.primary,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking;
    final days = _next7Days;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Reschedule Booking'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (booking != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(booking.serviceIcon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.serviceName,
                            style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
                        Text(
                          'Current: ${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}',
                          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          const Text('Select New Date',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, i) {
                final selected = _selectedDayIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = i),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.outline),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayLabel(days[i]),
                          style: TextStyle(
                            color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${days[i].day}',
                          style: TextStyle(
                            color: selected ? AppColors.onPrimary : AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('Select Time Slot',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, i) {
              final selected = _selectedSlot == _timeSlots[i];
              return GestureDetector(
                onTap: () => setState(() => _selectedSlot = _timeSlots[i]),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.outline),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _timeSlots[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? AppColors.primary : AppColors.onSurface,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _confirm,
              child: const Text('Confirm Reschedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
