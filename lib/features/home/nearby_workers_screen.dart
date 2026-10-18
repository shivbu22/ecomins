import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class NearbyWorkersScreen extends StatefulWidget {
  const NearbyWorkersScreen({super.key});

  @override
  State<NearbyWorkersScreen> createState() => _NearbyWorkersScreenState();
}

class _NearbyWorkersScreenState extends State<NearbyWorkersScreen> {
  String _filter = 'All';
  String _sort = 'By Rating';

  final List<String> _filters = ['All', 'Cleaning', 'Recycling', 'Garden'];
  final List<String> _sorts = ['By Rating', 'By Distance', 'By Price'];

  final List<_WorkerCard> _extraWorkers = const [
    _WorkerCard(id: 'worker_004', name: 'Kavitha Rao', emoji: '👩', rating: 4.6, services: ['Cleaning', 'Deep Clean'], distance: '1.5 km', serviceId: 'cleaning_basic'),
    _WorkerCard(id: 'worker_005', name: 'Mohan Das', emoji: '👨', rating: 4.5, services: ['Garden', 'Sweeper'], distance: '3.0 km', serviceId: 'garden_maintenance'),
  ];

  List<_WorkerCard> get _allWorkers {
    final fromMock = MockData.workers.map((w) => _WorkerCard(
      id: w.id,
      name: w.name,
      emoji: w.avatarEmoji,
      rating: w.rating,
      services: w.serviceIds.map((id) {
        for (final services in MockData.servicesByCategory.values) {
          for (final s in services) {
            if (s.id == id) return s.name;
          }
        }
        return id;
      }).take(2).toList(),
      distance: '${(MockData.workers.indexOf(w) + 1) * 0.8} km',
      serviceId: w.serviceIds.first,
    )).toList();
    return [...fromMock, ..._extraWorkers];
  }

  List<_WorkerCard> get _filtered {
    var workers = _allWorkers;
    if (_filter != 'All') {
      workers = workers.where((w) => w.services.any((s) => s.toLowerCase().contains(_filter.toLowerCase()))).toList();
    }
    if (_sort == 'By Rating') {
      workers.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == 'By Distance') {
      workers.sort((a, b) => double.parse(a.distance.split(' ')[0]).compareTo(double.parse(b.distance.split(' ')[0])));
    }
    return workers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Workers Near You'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location picker coming soon')),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary, size: 14),
                        SizedBox(width: 4),
                        Text('Koramangala, BLR', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 14),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  color: AppColors.surfaceContainerLow,
                  onSelected: (v) => setState(() => _sort = v),
                  itemBuilder: (_) => _sorts.map((s) => PopupMenuItem(
                    value: s,
                    child: Text(s, style: const TextStyle(color: AppColors.onSurface)),
                  )).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort, color: AppColors.onSurfaceVariant, size: 16),
                        const SizedBox(width: 4),
                        Text(_sort, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final selected = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (_) => setState(() => _filter = f),
                      backgroundColor: AppColors.surfaceContainer,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
                      side: BorderSide(color: selected ? AppColors.primary : AppColors.outline),
                      checkmarkColor: AppColors.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final w = _filtered[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Text(w.emoji, style: const TextStyle(fontSize: 36)),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.surfaceContainer, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(w.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
                            Text(w.services.join(', '), style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.primary, size: 12),
                                Text(' ${w.rating}', style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                                const SizedBox(width: 8),
                                const Icon(Icons.location_on, color: AppColors.outline, size: 12),
                                Text(' ${w.distance}', style: const TextStyle(color: AppColors.outline, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => context.push('/book/${w.serviceId}'),
                        child: const Text('Book', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerCard {
  const _WorkerCard({required this.id, required this.name, required this.emoji, required this.rating, required this.services, required this.distance, required this.serviceId});
  final String id;
  final String name;
  final String emoji;
  final double rating;
  final List<String> services;
  final String distance;
  final String serviceId;
}
