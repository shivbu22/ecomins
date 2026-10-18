import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecomins/data/models/personalization_models.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockMessages = <ChatMessage>[
  ChatMessage(
    id: 'msg_001',
    text: "Hi! I'm on my way. Will arrive in 8 minutes 🚗",
    senderId: 'worker_001',
    time: DateTime.now().subtract(const Duration(minutes: 12)),
    isWorker: true,
  ),
  ChatMessage(
    id: 'msg_002',
    text: 'Great! The door is open',
    senderId: 'mock_user_001',
    time: DateTime.now().subtract(const Duration(minutes: 10)),
    isWorker: false,
  ),
  ChatMessage(
    id: 'msg_003',
    text: 'Thank you! Starting the service now ✅',
    senderId: 'worker_001',
    time: DateTime.now().subtract(const Duration(minutes: 8)),
    isWorker: true,
  ),
  ChatMessage(
    id: 'msg_004',
    text: 'Service completed! Please check and confirm 🙏',
    senderId: 'worker_001',
    time: DateTime.now().subtract(const Duration(minutes: 2)),
    isWorker: true,
  ),
];

final _mockRecurring = <RecurringBooking>[
  const RecurringBooking(
    id: 'rb_001',
    serviceId: 'cleaning_basic',
    serviceName: 'Home Cleaning',
    serviceIcon: '🧹',
    frequency: 'weekly',
    nextDate: 'Every Monday',
    amount: 449,
    isActive: true,
  ),
  const RecurringBooking(
    id: 'rb_002',
    serviceId: 'garbage_daily',
    serviceName: 'Garbage Pickup',
    serviceIcon: '🗑️',
    frequency: 'daily',
    nextDate: 'Every day 8AM',
    amount: 99,
    isActive: true,
  ),
];

// ── Providers ─────────────────────────────────────────────────────────────────

final favoritesProvider = StateProvider<Set<String>>((ref) => {});

final recentlyViewedProvider = StateProvider<List<String>>(
  (ref) => ['cleaning_basic', 'recycling_paper'],
);

final homeProfileProvider =
    StateProvider<HomeProfile>((ref) => const HomeProfile());

final promoCodeProvider = StateProvider<String?>((ref) => null);

final appliedPromoProvider = StateProvider<PromoCode?>((ref) => null);

final workerChatProvider =
    StateProvider<List<ChatMessage>>((ref) => List.from(_mockMessages));

final tipAmountProvider = StateProvider<double>((ref) => 0);

final recurringBookingsProvider = StateProvider<List<RecurringBooking>>(
  (ref) => List.from(_mockRecurring),
);
