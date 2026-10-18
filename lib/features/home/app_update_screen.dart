import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

const _whatsNew = [
  'Smart scheduling improvements',
  'New eco badges & achievements',
  'Faster booking flow',
  'Carbon offset marketplace',
  'Bug fixes & performance',
];

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('New Update Available 🚀'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Text('🚀', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            const Text(
              'Ecomins v2.2.0',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'v2.1.0 → v2.2.0',
                style: TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's New",
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._whatsNew.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Text('✨',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const Spacer(),
            GradientButton(
              label: 'Update Now',
              icon: Icons.system_update_outlined,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Redirecting to store...')),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Later',
                style: TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
