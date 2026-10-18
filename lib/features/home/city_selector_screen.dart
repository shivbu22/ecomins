import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/location_providers.dart';

const _cities = [
  ('🏙️', 'Bangalore'),
  ('🌊', 'Mumbai'),
  ('🏛️', 'Delhi'),
  ('🌴', 'Chennai'),
  ('💎', 'Hyderabad'),
  ('🌸', 'Pune'),
  ('🎨', 'Kolkata'),
  ('🦁', 'Ahmedabad'),
];

class CitySelectorScreen extends ConsumerStatefulWidget {
  const CitySelectorScreen({super.key});

  @override
  ConsumerState<CitySelectorScreen> createState() => _CitySelectorScreenState();
}

class _CitySelectorScreenState extends ConsumerState<CitySelectorScreen> {
  String _query = '';

  List<(String, String)> get _filtered => _cities
      .where((c) => c.$2.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Select Your City'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location detected: Koramangala, BLR'),
                    backgroundColor: AppColors.surfaceContainer,
                  ),
                );
              },
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('Detect Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceContainer,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle:
                    const TextStyle(color: AppColors.onSurfaceVariant),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.outline),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular Cities',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final city = _filtered[i];
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedCityProvider.notifier).state =
                          city.$2;
                      context.pop(city.$2);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(city.$1,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text(
                            city.$2,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
