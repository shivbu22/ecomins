import 'user_model.dart';

export 'user_model.dart' show Address;

enum BookingStatus {
  pending,
  workerAssigned,
  workerEnRoute,
  inProgress,
  completed,
  cancelled,
}

enum ScheduleType { immediate, scheduled, recurring }

enum RecurrenceType { daily, weekly, monthly }

class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final String serviceIcon;
  final String workerId;
  final BookingStatus status;
  final Address serviceAddress;
  final DateTime scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double totalAmount;
  final String paymentMethod;
  final double? rating;
  final String? review;
  final ScheduleConfig scheduleConfig;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    this.workerId = '',
    required this.status,
    required this.serviceAddress,
    required this.scheduledAt,
    this.startedAt,
    this.completedAt,
    required this.totalAmount,
    required this.paymentMethod,
    this.rating,
    this.review,
    required this.scheduleConfig,
  });

  BookingModel copyWith({
    BookingStatus? status,
    double? rating,
    String? review,
    String? workerId,
  }) =>
      BookingModel(
        id: id,
        userId: userId,
        serviceId: serviceId,
        serviceName: serviceName,
        serviceIcon: serviceIcon,
        workerId: workerId ?? this.workerId,
        status: status ?? this.status,
        serviceAddress: serviceAddress,
        scheduledAt: scheduledAt,
        startedAt: startedAt,
        completedAt: completedAt,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        rating: rating ?? this.rating,
        review: review ?? this.review,
        scheduleConfig: scheduleConfig,
      );
}

class ScheduleConfig {
  final ScheduleType type;
  final DateTime? scheduledAt;
  final String? preferredTimeSlot;

  const ScheduleConfig({
    this.type = ScheduleType.immediate,
    this.scheduledAt,
    this.preferredTimeSlot,
  });
}
