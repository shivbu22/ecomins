class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final List<Address> savedAddresses;
  final EcoProfile ecoProfile;
  final WalletInfo wallet;

  const UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.savedAddresses = const [],
    required this.ecoProfile,
    required this.wallet,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    List<Address>? savedAddresses,
    EcoProfile? ecoProfile,
    WalletInfo? wallet,
  }) =>
      UserModel(
        uid: uid,
        name: name ?? this.name,
        phone: phone,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        savedAddresses: savedAddresses ?? this.savedAddresses,
        ecoProfile: ecoProfile ?? this.ecoProfile,
        wallet: wallet ?? this.wallet,
      );
}

class Address {
  final String id;
  final String label;
  final String fullAddress;
  final double latitude;
  final double longitude;

  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });
}

class EcoProfile {
  final int ecoPoints;
  final int carbonCredits;
  final double co2SavedKg;
  final int leaderboardRank;
  final List<String> badges;

  const EcoProfile({
    this.ecoPoints = 0,
    this.carbonCredits = 0,
    this.co2SavedKg = 0.0,
    this.leaderboardRank = 0,
    this.badges = const [],
  });

  EcoProfile copyWith({
    int? ecoPoints,
    int? carbonCredits,
    double? co2SavedKg,
  }) =>
      EcoProfile(
        ecoPoints: ecoPoints ?? this.ecoPoints,
        carbonCredits: carbonCredits ?? this.carbonCredits,
        co2SavedKg: co2SavedKg ?? this.co2SavedKg,
        leaderboardRank: leaderboardRank,
        badges: badges,
      );
}

class WalletInfo {
  final double balance;
  final String currency;

  const WalletInfo({
    this.balance = 0.0,
    this.currency = 'INR',
  });
}
