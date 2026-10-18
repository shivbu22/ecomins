import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// In-memory notifications list.
final notificationsProvider = StateProvider<List<NotificationItem>>((ref) {
  return MockData.notifications;
});

/// Count of unread notifications.
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

/// Backwards-compat: screens that used unreadCountProvider(uid).
final unreadCountByUidProvider = Provider.family<int, String>((ref, uid) {
  return ref.watch(unreadCountProvider);
});

/// Notification repository (in-memory).
final notificationRepositoryProvider = Provider<_NotificationService>((ref) {
  return _NotificationService(ref);
});

class _NotificationService {
  _NotificationService(this._ref);
  final Ref _ref;

  Future<void> markAsRead(String uid, String notificationId) async {
    final list = _ref.read(notificationsProvider);
    _ref.read(notificationsProvider.notifier).state = list.map((n) {
      if (n.id == notificationId) return n.copyWith(isRead: true);
      return n;
    }).toList();
  }

  Future<void> markAllAsRead(String uid) async {
    final list = _ref.read(notificationsProvider);
    _ref.read(notificationsProvider.notifier).state =
        list.map((n) => n.copyWith(isRead: true)).toList();
  }
}
