import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/booking_model.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';
import 'package:ecomins/shared/widgets/empty_state.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final all = MockData.bookings
        .where((b) => b.userId == user.uid)
        .toList();

    final active = all
        .where((b) =>
            b.status == BookingStatus.pending ||
            b.status == BookingStatus.workerAssigned ||
            b.status == BookingStatus.workerEnRoute ||
            b.status == BookingStatus.inProgress)
        .toList();
    final completed =
        all.where((b) => b.status == BookingStatus.completed).toList();
    final cancelled =
        all.where((b) => b.status == BookingStatus.cancelled).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('My Orders'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Active (${active.length})'),
            Tab(text: 'Completed (${completed.length})'),
            Tab(text: 'Cancelled (${cancelled.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BookingList(
            bookings: active,
            emptyEmoji: '📋',
            emptyTitle: 'No active orders',
            emptySubtitle: 'Book a service to get started',
            onRefresh: _onRefresh,
            tabType: _TabType.active,
          ),
          _BookingList(
            bookings: completed,
            emptyEmoji: '✅',
            emptyTitle: 'No completed orders',
            emptySubtitle: 'Your completed bookings will appear here',
            onRefresh: _onRefresh,
            tabType: _TabType.completed,
          ),
          _BookingList(
            bookings: cancelled,
            emptyEmoji: '❌',
            emptyTitle: 'No cancelled orders',
            emptySubtitle: 'Cancelled bookings will appear here',
            onRefresh: _onRefresh,
            tabType: _TabType.cancelled,
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

enum _TabType { active, completed, cancelled }

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.bookings,
    required this.emptyEmoji,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onRefresh,
    required this.tabType,
  });

  final List<BookingModel> bookings;
  final String emptyEmoji;
  final String emptyTitle;
  final String emptySubtitle;
  final Future<void> Function() onRefresh;
  final _TabType tabType;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyState(
        emoji: emptyEmoji,
        title: emptyTitle,
        subtitle: emptySubtitle,
        actionLabel: tabType == _TabType.active ? 'Book a Service' : null,
        onAction: tabType == _TabType.active
            ? () => context.push('/services/cleaning')
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainer,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) => _BookingCard(
          booking: bookings[index],
          tabType: tabType,
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.tabType});

  final BookingModel booking;
  final _TabType tabType;

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
      case BookingStatus.workerAssigned:
      case BookingStatus.workerEnRoute:
        return Colors.amber;
      case BookingStatus.inProgress:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  String _statusLabel(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.workerAssigned:
        return 'Assigned';
      case BookingStatus.workerEnRoute:
        return 'En Route';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRated = booking.rating != null;
    final dateStr =
        DateFormat('dd MMM yyyy').format(booking.scheduledAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Text(booking.serviceIcon,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.serviceName,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor(booking.status)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(booking.status),
                  style: TextStyle(
                    color: _statusColor(booking.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppColors.outline),
              const SizedBox(width: 4),
              Text(dateStr,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13)),
              const Spacer(),
              Text(
                '₹${booking.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          // Active tab: Track button
          if (tabType == _TabType.active) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context
                        .push('/booking/${booking.id}/tracking'),
                    icon: const Icon(Icons.location_on_outlined,
                        size: 16),
                    label: const Text('Track'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
          // Completed tab: rating + rebook
          if (tabType == _TabType.completed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (isRated) ...[
                  const Icon(Icons.star,
                      color: Color(0xFFFFC107), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.rating}',
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13),
                  ),
                  const Spacer(),
                ] else ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .push('/booking/${booking.id}/rate'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                            color: AppColors.primary),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Rate Service'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .push('/book/${booking.serviceId}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding:
                          const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Rebook'),
                  ),
                ),
              ],
            ),
          ],
          // Cancelled tab: reason + rebook
          if (tabType == _TabType.cancelled) ...[
            const SizedBox(height: 8),
            const Text(
              'Reason: Cancelled by user',
              style: TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    context.push('/book/${booking.serviceId}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Rebook'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
