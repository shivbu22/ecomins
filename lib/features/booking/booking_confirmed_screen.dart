import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/providers/booking_providers.dart';
import 'package:ecomins/shared/widgets/booking_status_stepper.dart';

class BookingConfirmedScreen extends ConsumerWidget {
  const BookingConfirmedScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(activeBookingProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Booking Confirmed',
          style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: AppColors.onSurface),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: booking == null
          ? const Center(
              child: Text('Booking not found',
                  style: TextStyle(color: AppColors.onSurfaceVariant)),
            )
          : _ConfirmedBody(booking: booking, bookingId: bookingId),
    );
  }
}

class _ConfirmedBody extends StatelessWidget {
  const _ConfirmedBody({required this.booking, required this.bookingId});

  final BookingModel booking;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0x1A3FE56C),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(
              child: Text('✅', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Booking Confirmed!',
            style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Booking #${bookingId.length >= 8 ? bookingId.substring(0, 8).toUpperCase() : bookingId.toUpperCase()}',
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _WorkerInfoCard(booking: booking),
          const SizedBox(height: 16),
          BookingStatusStepper(currentStatus: booking.status),
          const SizedBox(height: 16),
          _MapPlaceholder(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('/booking/$bookingId/tracking'),
            icon: const Icon(Icons.location_on),
            label: const Text('Track Live',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/booking/$bookingId/chat'),
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: const Text('Chat with Worker'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/booking/$bookingId/timeline'),
                  icon: const Icon(Icons.timeline_outlined, size: 18),
                  label: const Text('View Timeline'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _WorkerInfoCard extends StatelessWidget {
  const _WorkerInfoCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final hasWorker = booking.workerId.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x333C4A3C)),
      ),
      child: hasWorker
          ? Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Center(
                    child: Text('👨', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ravi Kumar',
                        style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                          const SizedBox(width: 3),
                          const Text('4.9',
                              style: TextStyle(
                                  color: AppColors.onSurfaceVariant, fontSize: 13)),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0x1A3FE56C),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Arriving in ~15 min',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
                SizedBox(width: 12),
                Text(
                  'Finding a worker nearby...',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x333C4A3C)),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, color: AppColors.onSurfaceVariant, size: 40),
            SizedBox(height: 8),
            Text('Map view',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
