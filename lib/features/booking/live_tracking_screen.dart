import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/booking_model.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/booking_providers.dart';
import 'package:ecomins/shared/widgets/booking_status_stepper.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(activeBookingProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Live Tracking'),
        leading: const BackButton(color: AppColors.onSurface),
      ),
      body: _TrackingBody(booking: booking, bookingId: bookingId),
    );
  }
}

class _TrackingBody extends ConsumerWidget {
  const _TrackingBody({required this.booking, required this.bookingId});

  final BookingModel? booking;
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerId = booking?.workerId ?? '';
    final location = workerId.isNotEmpty
        ? ref.watch(workerLocationProvider(workerId))
        : null;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.surfaceContainerLow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map_outlined, size: 64, color: AppColors.outline),
              const SizedBox(height: 12),
              const Text(
                'Live tracking map',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Worker is on the way',
                style: TextStyle(color: AppColors.outline, fontSize: 13),
              ),
              if (location != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Worker location: ${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
                  style: const TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomPanel(booking: booking),
        ),
      ],
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.booking});

  final BookingModel? booking;

  @override
  Widget build(BuildContext context) {
    final worker = MockData.workers.isNotEmpty ? MockData.workers.first : null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Color(0x44000000), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  worker?.avatarEmoji ?? '👨',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker?.name ?? 'Worker',
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          worker?.rating.toStringAsFixed(1) ?? '4.8',
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '~15 min away',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call feature coming soon')),
                  ),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat feature coming soon')),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (booking != null) BookingStatusStepper(currentStatus: booking!.status),
        ],
      ),
    );
  }
}
