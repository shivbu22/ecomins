import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/data/models/service_model.dart';

class ServiceComparisonScreen extends StatefulWidget {
  const ServiceComparisonScreen({super.key});

  @override
  State<ServiceComparisonScreen> createState() => _ServiceComparisonScreenState();
}

class _ServiceComparisonScreenState extends State<ServiceComparisonScreen> {
  ServiceModel? _serviceA;
  ServiceModel? _serviceB;

  List<ServiceModel> get _allServices {
    final list = <ServiceModel>[];
    for (final services in MockData.servicesByCategory.values) {
      list.addAll(services);
    }
    return list;
  }

  ServiceModel? get _cheaper {
    if (_serviceA == null || _serviceB == null) return null;
    return _serviceA!.basePrice <= _serviceB!.basePrice ? _serviceA : _serviceB;
  }

  ServiceModel? get _betterRated {
    if (_serviceA == null || _serviceB == null) return null;
    return _serviceA!.avgRating >= _serviceB!.avgRating ? _serviceA : _serviceB;
  }

  @override
  Widget build(BuildContext context) {
    final services = _allServices;
    final hasComparison = _serviceA != null && _serviceB != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Compare Services'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Selectors
                Row(
                  children: [
                    Expanded(child: _ServiceDropdown(
                      label: 'Service A',
                      value: _serviceA,
                      services: services,
                      onChanged: (s) => setState(() => _serviceA = s),
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('vs', style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: _ServiceDropdown(
                      label: 'Service B',
                      value: _serviceB,
                      services: services,
                      onChanged: (s) => setState(() => _serviceB = s),
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                if (hasComparison) ...[
                  const Text('Comparison', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  _ComparisonTable(serviceA: _serviceA!, serviceB: _serviceB!),
                ] else
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: const Text(
                      'Select two services to compare',
                      style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          if (hasComparison)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainer,
                        foregroundColor: AppColors.onSurface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.push('/book/${_cheaper!.id}'),
                      child: Text('Book Cheaper\n${_cheaper!.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.push('/book/${_betterRated!.id}'),
                      child: Text('Book Better Rated\n${_betterRated!.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceDropdown extends StatelessWidget {
  const _ServiceDropdown({required this.label, required this.value, required this.services, required this.onChanged});
  final String label;
  final ServiceModel? value;
  final List<ServiceModel> services;
  final ValueChanged<ServiceModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ServiceModel>(
          value: value,
          hint: Text(label, style: const TextStyle(color: AppColors.outline, fontSize: 13)),
          isExpanded: true,
          dropdownColor: AppColors.surfaceContainerLow,
          style: const TextStyle(color: AppColors.onSurface, fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.outline),
          items: services.map((s) => DropdownMenuItem(
            value: s,
            child: Text(s.name, overflow: TextOverflow.ellipsis),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.serviceA, required this.serviceB});
  final ServiceModel serviceA;
  final ServiceModel serviceB;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _Row('Price', '₹${serviceA.basePrice.toInt()}', '₹${serviceB.basePrice.toInt()}'),
      _Row('Rating', '${serviceA.avgRating}⭐', '${serviceB.avgRating}⭐'),
      _Row('Eco Points', '${serviceA.ecoPointsEarned.toInt()} pts', '${serviceB.ecoPointsEarned.toInt()} pts'),
      _Row('Eco Friendly', serviceA.isEcoFriendly ? '✅' : '❌', serviceB.isEcoFriendly ? '✅' : '❌'),
      _Row('Bookings', '${serviceA.totalBookings}', '${serviceB.totalBookings}'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: Text(serviceA.name,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  flex: 3,
                  child: Text(serviceB.name,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.outline, height: 1),
          ...rows.map((r) => _TableRow(row: r)),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.row});
  final _Row row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(row.label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13))),
          Expanded(flex: 3, child: Text(row.a, style: const TextStyle(color: AppColors.onSurface, fontSize: 13), textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text(row.b, style: const TextStyle(color: AppColors.onSurface, fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _Row {
  const _Row(this.label, this.a, this.b);
  final String label;
  final String a;
  final String b;
}
