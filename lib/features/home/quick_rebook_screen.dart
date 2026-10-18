import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class QuickRebookScreen extends ConsumerStatefulWidget {
  const QuickRebookScreen({super.key});

  @override
  ConsumerState<QuickRebookScreen> createState() => _QuickRebookScreenState();
}

class _QuickRebookScreenState extends ConsumerState<QuickRebookScreen> {
  bool _sameWorker = true;
  bool _sameTimeSlot = true;

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings
        .where((b) => b.userId == 'mock_user_001')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Quick Rebook ⚡'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Rebook your recent services in one tap',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Toggles
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Same worker',
                              style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text('Request Ravi Kumar again',
                              style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _sameWorker,
                      onChanged: (v) =>
                          setState(() => _sameWorker = v),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
                const Divider(color: Color(0x333C4A3C)),
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Same time slot',
                              style: TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text('Book for same day/time',
                              style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _sameTimeSlot,
                      onChanged: (v) =>
                          setState(() => _sameTimeSlot = v),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (bookings.isEmpty)
            const Center(
              child: Text('No recent bookings found.',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            )
          else
            ...bookings.map(
              (booking) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x333C4A3C)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(booking.serviceIcon,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.serviceName,
                                  style: const TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                  'Last booked: ${_formatDate(booking.scheduledAt)}',
                                  style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 12)),
                              const Text('Worker: Ravi Kumar',
                                  style: TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(
                            '₹${booking.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${booking.serviceName} rebooked!')),
                              );
                              context.push(
                                  '/booking/${booking.id}/confirmed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                            ),
                            child: const Text('Rebook Same',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context
                                .push('/book/${booking.serviceId}'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                            ),
                            child: const Text('With Changes',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}
