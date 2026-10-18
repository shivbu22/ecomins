import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/booking_model.dart';

class BookingStatusStepper extends StatelessWidget {
  const BookingStatusStepper({super.key, required this.currentStatus});

  final BookingStatus currentStatus;

  static const _steps = [
    _Step(label: 'Assigned', status: BookingStatus.workerAssigned),
    _Step(label: 'En Route', status: BookingStatus.workerEnRoute),
    _Step(label: 'In Progress', status: BookingStatus.inProgress),
    _Step(label: 'Completed', status: BookingStatus.completed),
  ];

  int get _currentIndex {
    for (int i = _steps.length - 1; i >= 0; i--) {
      if (_statusIndex(currentStatus) >= _statusIndex(_steps[i].status)) {
        return i;
      }
    }
    return -1;
  }

  int _statusIndex(BookingStatus s) {
    const order = [
      BookingStatus.pending,
      BookingStatus.workerAssigned,
      BookingStatus.workerEnRoute,
      BookingStatus.inProgress,
      BookingStatus.completed,
      BookingStatus.cancelled,
    ];
    return order.indexOf(s);
  }

  @override
  Widget build(BuildContext context) {
    final activeIdx = _currentIndex;

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        // Connector lines
        if (i.isOdd) {
          final stepIdx = i ~/ 2;
          final isDone = stepIdx < activeIdx;
          return Expanded(
            child: Container(
              height: 2,
              color: isDone ? AppColors.primary : AppColors.outline,
            ),
          );
        }

        final stepIdx = i ~/ 2;
        final step = _steps[stepIdx];
        final isDone = stepIdx < activeIdx;
        final isActive = stepIdx == activeIdx;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDone || isActive)
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: (isDone || isActive)
                      ? AppColors.primary
                      : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: AppColors.onPrimary)
                  : isActive
                      ? const Icon(Icons.circle, size: 10, color: AppColors.onPrimary)
                      : null,
            ),
            const SizedBox(height: 6),
            Text(
              step.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                color: (isDone || isActive)
                    ? AppColors.primary
                    : AppColors.outline,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Step {
  const _Step({required this.label, required this.status});
  final String label;
  final BookingStatus status;
}
