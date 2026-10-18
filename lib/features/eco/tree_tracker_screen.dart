import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

const _treePlantDates = [
  ('🌱', '12 Sep 2024', 'Bannerghatta, Bangalore'),
  ('🌿', '28 Aug 2024', 'Cubbon Park, Bangalore'),
  ('🌳', '15 Jul 2024', 'Western Ghats, Karnataka'),
  ('🌳', '02 Jun 2024', 'Nagarhole, Karnataka'),
  ('🌿', '18 Apr 2024', 'Coorg, Karnataka'),
  ('🌱', '05 Mar 2024', 'Mysore, Karnataka'),
];

class TreeTrackerScreen extends ConsumerWidget {
  const TreeTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final treeCount = (user.ecoProfile.ecoPoints / 200).floor();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Your Forest 🌳'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🌳', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(
                  "You've helped plant $treeCount trees",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Every eco service plants a tree 🌱',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Forest',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: _treePlantDates.length,
            itemBuilder: (context, i) {
              final tree = _treePlantDates[i];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Planted on ${tree.$2} in ${tree.$3}'),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(tree.$1,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('🌍', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Forest',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Ecomins community has planted 12,450 trees',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: 'Plant More Trees',
            icon: Icons.park_outlined,
            onTap: () => context.push('/eco/rewards'),
          ),
        ],
      ),
    );
  }
}
