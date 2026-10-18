import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// All service categories from mock data.
final serviceCategoriesProvider = Provider<List<ServiceCategory>>((ref) {
  return MockData.categories;
});

/// Services for a given category ID.
final servicesByCategoryProvider = Provider.family<List<ServiceModel>, String>((ref, categoryId) {
  return MockData.servicesByCategory[categoryId] ?? [];
});

/// A single service by ID (searches all categories).
final serviceByIdProvider = Provider.family<ServiceModel?, String>((ref, serviceId) {
  for (final services in MockData.servicesByCategory.values) {
    for (final service in services) {
      if (service.id == serviceId) return service;
    }
  }
  return null;
});

/// All services across all categories.
final allServicesProvider = Provider<List<ServiceModel>>((ref) {
  return MockData.servicesByCategory.values.expand((s) => s).toList();
});
