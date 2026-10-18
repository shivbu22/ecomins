import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/data/models/booking_model.dart';

class BookingCancelScreen extends StatefulWidget {
  const BookingCancelScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<BookingCancelScreen> createState() => _BookingCancelScreenState();
}

class _BookingCancelScreenState extends State<BookingCancelScreen> {
  String _selectedReason = 'Changed plans';
  final List<String> _reasons = ['Changed plans', 'Found another service', 'Emergency', 'Other'];

  BookingModel? get _booking {
    try {
      return MockData.bookings.firstWhere((b) => b.id == widget.bookingId);
    } catch (_) {
      return MockData.bookings.isNotEmpty ? MockData.bookings.first : null;
    }
  }

  void _confirmCancellation() {
    final idx = MockData.bookings.indexWhere((b) => b.id == widget.bookingId);
    if (idx != -1) {
      MockData.bookings[idx] = MockData.bookings[idx].copyWith(status: BookingStatus.cancelled);
    }
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Cancel Booking'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(booking.serviceIcon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.serviceName,
                                style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
                            Text(
                              '${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}',
                              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${booking.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Text('Reason for cancellation',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: _reasons.map((r) {
                return RadioListTile<String>(
                  value: r,
                  groupValue: _selectedReason,
                  onChanged: (v) => setState(() => _selectedReason = v!),
                  title: Text(r, style: const TextStyle(color: AppColors.onSurface)),
                  activeColor: AppColors.primary,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '₹${booking?.totalAmount.toStringAsFixed(0) ?? '0'} will be refunded to your wallet within 24 hours',
                    style: const TextStyle(color: AppColors.onSurface, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onError,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _confirmCancellation,
              child: const Text('Confirm Cancellation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                side: const BorderSide(color: AppColors.outline),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => context.pop(),
              child: const Text('Keep Booking', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
