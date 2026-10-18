enum WorkerStatus { available, enRoute, busy, offline }

class WorkerModel {
  final String id;
  final String name;
  final String avatarEmoji;
  final String phone;
  final List<String> serviceIds;
  final double rating;
  final int totalJobs;
  final WorkerStatus status;
  final List<String> certifications;
  final double ecoScore;

  const WorkerModel({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.phone,
    this.serviceIds = const [],
    this.rating = 4.8,
    this.totalJobs = 0,
    this.status = WorkerStatus.available,
    this.certifications = const [],
    this.ecoScore = 0.0,
  });
}
