import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class ServiceMapScreen extends StatefulWidget {
  const ServiceMapScreen({super.key});

  @override
  State<ServiceMapScreen> createState() => _ServiceMapScreenState();
}

class _ServiceMapScreenState extends State<ServiceMapScreen> with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Cleaning', 'Recycling', 'Garden'];

  final List<_NearbyWorker> _workers = const [
    _NearbyWorker(id: 'cleaning_basic', name: 'Ravi Kumar', service: 'Cleaning', distance: '0.8 km', emoji: '👨'),
    _NearbyWorker(id: 'recycling_paper', name: 'Priya Devi', service: 'Recycling', distance: '1.2 km', emoji: '👩'),
    _NearbyWorker(id: 'garden_maintenance', name: 'Suresh Babu', service: 'Garden', distance: '2.1 km', emoji: '👨'),
  ];

  late List<AnimationController> _pulseControllers;
  late List<Animation<double>> _pulseAnimations;

  final List<Offset> _dotPositions = const [
    Offset(0.3, 0.4),
    Offset(0.6, 0.3),
    Offset(0.5, 0.65),
  ];

  @override
  void initState() {
    super.initState();
    _pulseControllers = List.generate(3, (i) => AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200 + i * 300),
    )..repeat(reverse: true));
    _pulseAnimations = _pulseControllers.map((c) =>
      Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut))
    ).toList();
  }

  @override
  void dispose() {
    for (final c in _pulseControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<_NearbyWorker> get _filteredWorkers {
    if (_selectedFilter == 'All') return _workers;
    return _workers.where((w) => w.service == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Find Services Near You'),
      ),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFF0D1A0D),
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                    child: Container(),
                  ),
                ),
                // Pulsing dots
                ...List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _pulseAnimations[i],
                    builder: (context, _) {
                      return Positioned(
                        left: MediaQuery.of(context).size.width * _dotPositions[i].dx - 16,
                        top: (MediaQuery.of(context).size.height * 0.45) * _dotPositions[i].dy - 16,
                        child: Transform.scale(
                          scale: _pulseAnimations[i].value,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Center(
                              child: Text('👷', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Location pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_pin, color: AppColors.error, size: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('You are here', style: TextStyle(color: AppColors.onSurface, fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final selected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedFilter = f),
                      backgroundColor: AppColors.surfaceContainer,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(color: selected ? AppColors.primary : AppColors.outline),
                      checkmarkColor: AppColors.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Bottom sheet workers list
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_filteredWorkers.length} workers nearby',
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 10),
                ..._filteredWorkers.map((w) => _WorkerTile(worker: w)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerTile extends StatelessWidget {
  const _WorkerTile({required this.worker});
  final _NearbyWorker worker;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(worker.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                Text('${worker.service} • ${worker.distance}',
                    style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
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
            onPressed: () => context.push('/book/${worker.id}'),
            child: const Text('Book', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _NearbyWorker {
  const _NearbyWorker({required this.id, required this.name, required this.service, required this.distance, required this.emoji});
  final String id;
  final String name;
  final String service;
  final String distance;
  final String emoji;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A3A1A)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw some mock roads
    final roadPaint = Paint()..color = const Color(0xFF2A4A2A)..strokeWidth = 3;
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
