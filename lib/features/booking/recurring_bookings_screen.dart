import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/personalization_models.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class RecurringBookingsScreen extends ConsumerWidget {
  const RecurringBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(recurringBookingsProvider);
    final totalMonthly = bookings
        .where((b) => b.isActive)
        .fold<double>(0, (sum, b) {
      if (b.frequency == 'daily') return sum + b.amount * 30;
      if (b.frequency == 'weekly') return sum + b.amount * 4;
      return sum + b.amount;
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Recurring Services'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: () => _showServicePicker(context),
        child: const Icon(Icons.add),
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No recurring bookings.\nSet up auto-scheduling to never miss a service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 15),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Monthly spend card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Monthly Spend',
                              style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                          Text(
                            '₹${totalMonthly.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...bookings.map(
                  (b) => _RecurringCard(
                    booking: b,
                    onPause: () {
                      final updated = bookings
                          .map((x) => x.id == b.id
                              ? x.copyWith(isActive: !x.isActive)
                              : x)
                          .toList();
                      ref
                          .read(recurringBookingsProvider.notifier)
                          .state = updated;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(b.isActive
                              ? '${b.serviceName} paused'
                              : '${b.serviceName} resumed'),
                        ),
                      );
                    },
                    onCancel: () =>
                        _confirmCancel(context, ref, bookings, b),
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref,
      List<RecurringBooking> bookings, RecurringBooking b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Cancel Recurring?',
            style: TextStyle(color: AppColors.onSurface)),
        content: Text('Cancel ${b.serviceName} recurring booking?',
            style: const TextStyle(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(recurringBookingsProvider.notifier).state =
                  bookings.where((x) => x.id != b.id).toList();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${b.serviceName} recurring cancelled')),
              );
            },
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showServicePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Recurring Service',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ('🧹', 'Home Cleaning', 'weekly'),
              ('🗑️', 'Garbage Pickup', 'daily'),
              ('🌱', 'Garden Care', 'monthly'),
            ].map(
              (item) => ListTile(
                leading: Text(item.$1,
                    style: const TextStyle(fontSize: 22)),
                title: Text(item.$2,
                    style: const TextStyle(color: AppColors.onSurface)),
                subtitle: Text(item.$3,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${item.$2} added as recurring!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecurringCard extends StatelessWidget {
  const _RecurringCard({
    required this.booking,
    required this.onPause,
    required this.onCancel,
  });

  final RecurringBooking booking;
  final VoidCallback onPause;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: booking.isActive
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0x333C4A3C),
        ),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    Text(
                        '${booking.frequency[0].toUpperCase()}${booking.frequency.substring(1)} · ${booking.nextDate}',
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12)),
                  ],
                ),
              ),
              Text('₹${booking.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (!booking.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Paused',
                      style: TextStyle(
                          color: AppColors.error, fontSize: 11)),
                ),
              const Spacer(),
              TextButton(
                onPressed: onPause,
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.onSurfaceVariant),
                child: Text(booking.isActive ? 'Pause' : 'Resume'),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.error),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
