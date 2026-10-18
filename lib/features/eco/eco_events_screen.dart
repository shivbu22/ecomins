import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class EcoEventsScreen extends StatelessWidget {
  const EcoEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Eco Events'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined, size: 64, color: AppColors.outline),
            SizedBox(height: 16),
            Text(
              'Eco events coming soon',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Stay tuned for upcoming eco workshops\nand community events',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.outline, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
