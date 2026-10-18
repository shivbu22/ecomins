import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// Mock location — Bangalore city centre.
final locationProvider = Provider<({double lat, double lng})>((ref) {
  return (lat: 12.9716, lng: 77.5946);
});

/// Currently selected city name.
final selectedCityProvider = StateProvider<String>((ref) => 'Bangalore');

/// Returns mock nearby workers for a given service ID.
final nearbyWorkersProvider = Provider.family<List<WorkerModel>, String>((ref, serviceId) {
  if (serviceId.isEmpty) return MockData.workers;
  return MockData.workers
      .where((w) => w.serviceIds.contains(serviceId) || w.status == WorkerStatus.available)
      .toList();
});