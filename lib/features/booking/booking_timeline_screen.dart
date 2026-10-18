import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class BookingTimelineScreen extends StatelessWidget {
  const BookingTimelineScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final steps = [
      const _TimelineStep(
        icon: '✅',
        title: 'Booking Created',
        time: '10:30 AM',
        description: 'Your booking was confirmed',
        isDone: true,
        isCurrent: false,
      ),
      const _TimelineStep(
        icon: '✅',
        title: 'Worker Assigned',
        time: '10:32 AM',
        description: 'Ravi Kumar assigned to your booking',
        isDone: true,
        isCurrent: false,
      ),
      const _TimelineStep(
        icon: '✅',
        title: 'Worker En Route',
        time: '10:45 AM',
        description: 'Worker is on the way to your location',
        isDone: true,
        isCurrent: false,
      ),
      const _TimelineStep(
        icon: '🔄',
        title: 'Service In Progress',
        time: '11:00 AM',
        description: 'Service is currently being performed',
        isDone: false,
        isCurrent: true,
      ),
      const _TimelineStep(
        icon: '⏳',
        title: 'Service Completed',
        time: 'Pending',
        description: 'Awaiting service completion',
        isDone: false,
        isCurrent: false,
      ),
      const _TimelineStep(
        icon: '⏳',
        title: 'Payment Processed',
        time: 'Pending',
        description: 'Payment will be processed after completion',
        isDone: false,
        isCurrent: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Booking Timeline'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                final isLast = index == steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline line + dot
                    Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: step.isDone
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : step.isCurrent
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.surfaceContainerLow,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: step.isDone || step.isCurrent
                                  ? AppColors.primary
                                  : const Color(0x333C4A3C),
                              width: step.isCurrent ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(step.icon,
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 50,
                            color: step.isDone
                                ? AppColors.primary.withValues(alpha: 0.4)
                                : const Color(0x333C4A3C),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(step.title,
                                      style: TextStyle(
                                          color: step.isCurrent
                                              ? AppColors.primary
                                              : AppColors.onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Text(step.time,
                                    style: const TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(step.description,
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/booking/$bookingId/tracking'),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Track on Map'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/booking/$bookingId/chat'),
                    icon: const Icon(Icons.chat_outlined, size: 18),
                    label: const Text('Contact Worker'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
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

class _TimelineStep {
  final String icon, title, time, description;
  final bool isDone, isCurrent;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.time,
    required this.description,
    required this.isDone,
    required this.isCurrent,
  });
}
