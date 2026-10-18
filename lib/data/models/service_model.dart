class ServiceModel {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String iconAsset;
  final double basePrice;
  final String unit;
  final List<ServicePackage> packages;
  final double avgRating;
  final int totalBookings;
  final bool isEcoFriendly;
  final double ecoPointsEarned;

  const ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.basePrice,
    required this.unit,
    this.packages = const [],
    this.avgRating = 4.5,
    this.totalBookings = 0,
    this.isEcoFriendly = false,
    this.ecoPointsEarned = 10,
  });
}

class ServiceCategory {
  final String id;
  final String name;
  final String iconAsset;
  final String color;
  final List<String> serviceIds;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.color,
    this.serviceIds = const [],
  });
}

class ServicePackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;

  const ServicePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
  });
}
