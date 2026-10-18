import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/service_model.dart';

class ServiceCategoryCard extends StatelessWidget {
  const ServiceCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final ServiceCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColors.surfaceContainer,
        highlightColor: AppColors.surfaceContainer,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0x333C4A3C),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon — use emoji text if iconAsset looks like an emoji, else Material icon
              Text(
                category.iconAsset,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 10),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
