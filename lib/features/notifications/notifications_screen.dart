import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/core/utils/extensions.dart';
import 'package:ecomins/data/models/notification_model.dart';
import 'package:ecomins/providers/notification_providers.dart';

/// Production notifications screen with date grouping, swipe-to-dismiss,
/// mark all read, and type-specific icons.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifService = ref.read(notificationRepositoryProvider);

    // Group by date label
    final grouped = _groupByDate(notifications);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Text('Notifications', style: AppTextStyles.h3),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                await notifService.markAllAsRead('');
                if (context.mounted) context.showSuccess('All marked as read');
              },
              child: Text('Mark all read',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final entry = grouped[index];
                if (entry is String) {
                  // Date header
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(entry, style: AppTextStyles.label),
                  );
                }
                final notif = entry as NotificationItem;
                return Dismissible(
                  key: Key(notif.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.errorContainer,
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.onErrorContainer),
                  ),
                  onDismissed: (_) {
                    final list = List<NotificationItem>.from(
                        ref.read(notificationsProvider));
                    list.removeWhere((n) => n.id == notif.id);
                    ref.read(notificationsProvider.notifier).state = list;
                  },
                  child: _NotificationTile(
                    notification: notif,
                    onTap: () async {
                      await notifService.markAsRead('', notif.id);
                      if (notif.targetRoute != null && context.mounted) {
                        context.push(notif.targetRoute!);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  /// Returns a flat list of [String] (date headers) and [NotificationItem].
  List<dynamic> _groupByDate(List<NotificationItem> notifications) {
    final result = <dynamic>[];
    String? lastLabel;

    for (final notif in notifications) {
      final label = _dateLabel(notif.createdAt);
      if (label != lastLabel) {
        result.add(label);
        lastLabel = label;
      }
      result.add(notif);
    }
    return result;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays <= 7) return 'This Week';
    return 'Earlier';
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.bookingUpdate:
        return Icons.receipt_long_outlined;
      case NotificationType.ecoMilestone:
        return Icons.eco_outlined;
      case NotificationType.badge:
        return Icons.emoji_events_outlined;
      case NotificationType.general:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.bookingUpdate:
        return const Color(0xFF4FC3F7);
      case NotificationType.ecoMilestone:
        return AppColors.primary;
      case NotificationType.badge:
        return const Color(0xFFFFD700);
      case NotificationType.general:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _colorForType(notification.type);
    final timeStr = AppUtils.relativeTime(notification.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: notification.isRead
            ? AppDecorations.card()
            : AppDecorations.card().copyWith(
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon with colored background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconForType(notification.type),
                  color: typeColor, size: 20),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: notification.isRead
                        ? AppTextStyles.body
                        : AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(timeStr, style: AppTextStyles.caption),
                ],
              ),
            ),

            // Unread dot
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4, left: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined,
                size: 40, color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Text('No notifications yet', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text("You're all caught up!", style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
