class HomeProfile {
  final String homeType;
  final int residents;
  final bool hasPets;
  final bool hasGarden;
  final List<String> preferredTimeSlots;

  const HomeProfile({
    this.homeType = '2BHK',
    this.residents = 2,
    this.hasPets = false,
    this.hasGarden = false,
    this.preferredTimeSlots = const ['morning'],
  });

  HomeProfile copyWith({
    String? homeType,
    int? residents,
    bool? hasPets,
    bool? hasGarden,
    List<String>? preferredTimeSlots,
  }) =>
      HomeProfile(
        homeType: homeType ?? this.homeType,
        residents: residents ?? this.residents,
        hasPets: hasPets ?? this.hasPets,
        hasGarden: hasGarden ?? this.hasGarden,
        preferredTimeSlots: preferredTimeSlots ?? this.preferredTimeSlots,
      );
}

class PromoCode {
  final String code;
  final String description;
  final double discountPercent;
  final double maxDiscount;

  const PromoCode({
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.maxDiscount,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final DateTime time;
  final bool isWorker;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.time,
    required this.isWorker,
  });
}

class RecurringBooking {
  final String id;
  final String serviceId;
  final String serviceName;
  final String serviceIcon;
  final String frequency;
  final String nextDate;
  final double amount;
  final bool isActive;

  const RecurringBooking({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    required this.frequency,
    required this.nextDate,
    required this.amount,
    this.isActive = true,
  });

  RecurringBooking copyWith({bool? isActive}) => RecurringBooking(
        id: id,
        serviceId: serviceId,
        serviceName: serviceName,
        serviceIcon: serviceIcon,
        frequency: frequency,
        nextDate: nextDate,
        amount: amount,
        isActive: isActive ?? this.isActive,
      );
}
