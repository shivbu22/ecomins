import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

// ── BookingFormState ──────────────────────────────────────────────────────────

class BookingFormState {
  const BookingFormState({
    this.selectedPackage,
    this.selectedAddress,
    this.scheduleConfig,
    this.paymentMethod,
    this.serviceId,
  });

  final ServicePackage? selectedPackage;
  final Address? selectedAddress;
  final ScheduleConfig? scheduleConfig;
  final String? paymentMethod;
  final String? serviceId;

  BookingFormState copyWith({
    ServicePackage? selectedPackage,
    Address? selectedAddress,
    ScheduleConfig? scheduleConfig,
    String? paymentMethod,
    String? serviceId,
  }) {
    return BookingFormState(
      selectedPackage: selectedPackage ?? this.selectedPackage,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      scheduleConfig: scheduleConfig ?? this.scheduleConfig,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      serviceId: serviceId ?? this.serviceId,
    );
  }
}

// ── BookingFormNotifier ───────────────────────────────────────────────────────

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(const BookingFormState());

  void setPackage(ServicePackage package) {
    state = state.copyWith(selectedPackage: package);
  }

  void setAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setScheduleConfig(ScheduleConfig config) {
    state = state.copyWith(scheduleConfig: config);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setServiceId(String serviceId) {
    state = state.copyWith(serviceId: serviceId);
  }

  void reset() {
    state = const BookingFormState();
  }
}

// ── In-memory booking service ─────────────────────────────────────────────────

class _BookingService {
  /// Creates a booking and adds it to MockData.bookings.
  Future<String> createBooking(BookingModel booking) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newBooking = BookingModel(
      id: id,
      userId: booking.userId,
      serviceId: booking.serviceId,
      serviceName: booking.serviceName,
      serviceIcon: booking.serviceIcon,
      workerId: booking.workerId,
      status: booking.status,
      serviceAddress: booking.serviceAddress,
      scheduledAt: booking.scheduledAt,
      totalAmount: booking.totalAmount,
      paymentMethod: booking.paymentMethod,
      scheduleConfig: booking.scheduleConfig,
    );
    MockData.bookings.insert(0, newBooking);
    return id;
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    final idx = MockData.bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      MockData.bookings[idx] = MockData.bookings[idx].copyWith(status: status);
    }
  }

  Future<void> submitRating(String bookingId, double rating, String? review) async {
    final idx = MockData.bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      MockData.bookings[idx] = MockData.bookings[idx].copyWith(
        rating: rating,
        review: review,
        status: BookingStatus.completed,
      );
    }
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    return MockData.bookings.where((b) => b.userId == userId).toList();
  }

  BookingModel? getBookingById(String bookingId) {
    try {
      return MockData.bookings.firstWhere((b) => b.id == bookingId);
    } catch (_) {
      return null;
    }
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

/// Holds the multi-step booking form state.
final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
  return BookingFormNotifier();
});

/// In-memory booking service (replaces BookingRepository).
final bookingRepositoryProvider = Provider<_BookingService>((ref) {
  return _BookingService();
});

/// Returns a booking by ID from in-memory list.
final activeBookingProvider = Provider.family<BookingModel?, String>((ref, bookingId) {
  try {
    return MockData.bookings.firstWhere((b) => b.id == bookingId);
  } catch (_) {
    return null;
  }
});

/// Mock worker location (Bangalore coordinates).
final workerLocationProvider = Provider.family<({double lat, double lng})?, String>((ref, workerId) {
  if (workerId.isEmpty) return null;
  return (lat: 12.9352, lng: 77.6245);
});
