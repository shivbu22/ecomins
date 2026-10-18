import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// Persistent banner shown on home when there's an active booking.
class ActiveBookingBanner extends StatelessWidget {
  const ActiveBookingBanner({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final worker = MockData.workers
        .where((w) => w.id == booking.workerId)
        .firstOrNull;
    final workerName = worker?.name.split(' ').first ?? 'Worker';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _PingDot(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '🔄 $workerName is on the way — 8 min',
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.push('/booking/${booking.id}/tracking'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Track',
                      style: AppTextStyles.label.copyWith(
                          color: AppColors.onPrimary)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Animated progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated pulsing green dot
class _PingDot extends StatefulWidget {
  const _PingDot();

  @override
  State<_PingDot> createState() => _PingDotState();
}

class _PingDotState extends State<_PingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _scale = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Transform.scale(
              scale: _scale.value,
              child: Opacity(
                opacity: _opacity.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
