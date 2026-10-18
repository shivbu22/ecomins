enum RewardType { voucher, product, experience, donation }

class EcoReward {
  final String id;
  final String title;
  final String description;
  final String imageEmoji;
  final int pointsCost;
  final RewardType type;
  final DateTime expiresAt;
  final bool isAvailable;

  const EcoReward({
    required this.id,
    required this.title,
    required this.description,
    required this.imageEmoji,
    required this.pointsCost,
    required this.type,
    required this.expiresAt,
    this.isAvailable = true,
  });
}

class CarbonCredit {
  final String id;
  final String projectName;
  final String description;
  final double priceInr;
  final double co2TonnesOffset;
  final String verificationStandard;

  const CarbonCredit({
    required this.id,
    required this.projectName,
    required this.description,
    required this.priceInr,
    required this.co2TonnesOffset,
    required this.verificationStandard,
  });
}

class LeaderboardEntry {
  final String userId;
  final String displayName;
  final String? avatarEmoji;
  final int ecoPoints;
  final int rank;
  final String badge;

  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    this.avatarEmoji,
    required this.ecoPoints,
    required this.rank,
    required this.badge,
  });
}

class EcoEvent {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String location;
  final DateTime startDate;
  final int ecoPointsReward;
  final bool isOnline;

  const EcoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.location,
    required this.startDate,
    required this.ecoPointsReward,
    this.isOnline = false,
  });
}
